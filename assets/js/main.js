// Main JavaScript file for La Délicatesse

// Global variables
let currentUser = null
let chefs = []
let recipes = []

// Initialize the application
document.addEventListener("DOMContentLoaded", async () => {
  await checkAuthStatus()
  addMobileLanguageButton()
  
  // Only load chefs and recipes on the main index page
  const path = window.location.pathname
  if (path === '/' || path.includes('index.html') || path.endsWith('/la-delicatesse/')) {
    loadChefs()
    loadRecipes()
  }
  
  setupEventListeners()
  initializeAnimations()
  setupGlobalErrorHandler()
  setupTokenRefresh()
  handleUrlRouting()
  setupBookingEventListeners()
  
  // Initialize translations with saved language preference
  const savedLanguage = localStorage.getItem('preferredLanguage')
  if (savedLanguage) {
    window.currentLanguage = savedLanguage
    console.log('Cargando idioma guardado:', window.currentLanguage)
  }
  
  // Translate the page
  translatePage()
  
  // Update language toggle after a small delay to ensure DOM is ready
  setTimeout(() => {
    updateLanguageToggle()
  }, 100)
})

// Setup booking event listeners
function setupBookingEventListeners() {
  // Price calculation listeners
  const durationInput = document.getElementById('serviceDuration')
  const dinersInput = document.getElementById('numberOfDiners')
  
  if (durationInput) {
    durationInput.addEventListener('input', updateBookingPrice)
  }
  
  if (dinersInput) {
    dinersInput.addEventListener('input', updateBookingPrice)
  }
  
  // Booking form submission
  const bookingForm = document.getElementById('bookingForm')
  if (bookingForm) {
    bookingForm.addEventListener('submit', handleBookingSubmission)
  }
}

// Setup automatic token refresh
function setupTokenRefresh() {
  // Check token expiration every 5 minutes
  setInterval(() => {
    const token = localStorage.getItem("authToken")
    if (token && currentUser) {
      try {
        const tokenData = JSON.parse(atob(token))
        const currentTime = Math.floor(Date.now() / 1000)
        const timeUntilExpiry = tokenData.exp - currentTime
        
        // If token expires in less than 1 hour, show warning
        if (timeUntilExpiry < 3600 && timeUntilExpiry > 0) {
          showToast('Tu sesión expirará pronto. Guarda tu trabajo.', 'warning')
        }
        
        // If token is expired, clear session
        if (timeUntilExpiry <= 0) {
          console.warn('Token expirado, cerrando sesión...')
          clearSession()
          showToast('Tu sesión ha expirado. Por favor, inicia sesión nuevamente.', 'error')
        }
      } catch (error) {
        console.error('Error checking token expiration:', error)
      }
    }
  }, 5 * 60 * 1000) // Check every 5 minutes
}

// Setup global error handler for authentication
function setupGlobalErrorHandler() {
  // Override fetch to handle 401 errors globally
  const originalFetch = window.fetch
  window.fetch = async function(...args) {
    try {
      const response = await originalFetch.apply(this, args)
      
      // Check if response is 401 (Unauthorized)
      if (response.status === 401) {
        const result = await response.json()
        if (result.message && result.message.includes('Token') || result.message.includes('autorizado')) {
          console.warn('Token expirado o inválido, cerrando sesión...')
          clearSession()
          showToast('Tu sesión ha expirado. Por favor, inicia sesión nuevamente.', 'warning')
        }
      }
      
      return response
    } catch (error) {
      throw error
    }
  }
}

// Add mobile language button for non-logged users
function addMobileLanguageButton() {
  const mobileMenu = document.querySelector('.mobile-menu');
  if (!mobileMenu) return;
  
  // Verificar si ya existe el botón para evitar duplicados
  if (document.querySelector('.mobile-language-button')) return;
  
  // Crear botón de idioma para móvil
  const mobileLanguageButton = document.createElement('button');
  mobileLanguageButton.className = 'mobile-language-button';
  
  // Establecer el texto inicial según el idioma actual
  const currentLang = window.currentLanguage || 'es';
  // Si el idioma actual es español, mostrar 'EN' (para cambiar a inglés)
  // Si el idioma actual es inglés, mostrar 'ES' (para cambiar a español)
  mobileLanguageButton.textContent = currentLang === 'es' ? 'EN' : 'ES';
  
  mobileLanguageButton.onclick = function() {
    // Cambiar al idioma opuesto del actual
    const newLang = window.currentLanguage === 'es' ? 'en' : 'es';
    changeLanguage(newLang);
    
    // Actualizar el texto del botón después de cambiar el idioma
    // Si el nuevo idioma es español, mostrar 'EN' (para cambiar a inglés)
    // Si el nuevo idioma es inglés, mostrar 'ES' (para cambiar a español)
    mobileLanguageButton.textContent = newLang === 'es' ? 'EN' : 'ES';
  };
  
  // Agregar el botón al menú móvil
  mobileMenu.appendChild(mobileLanguageButton);
}

// Check if user is authenticated
async function checkAuthStatus() {
  const token = localStorage.getItem("authToken")
  const userData = localStorage.getItem("userData")

  if (token && userData) {
    try {
      // Validate token with server
      const response = await fetch("api/auth/validate.php", {
        method: "GET",
        headers: {
          "Authorization": `Bearer ${token}`
        }
      })

      const result = await response.json()

      if (result.success) {
        currentUser = JSON.parse(userData)
        updateUIForLoggedInUser()
      } else {
        // Token is invalid, clear session
        clearSession()
      }
    } catch (error) {
      console.error("Error validating token:", error)
      // On network error, still show user as logged in but with limited functionality
      currentUser = JSON.parse(userData)
      updateUIForLoggedInUser()
    }
  }
}

// Clear user session
function clearSession() {
  localStorage.removeItem("authToken")
  localStorage.removeItem("userData")
  currentUser = null
  // Update UI to show login buttons
  const authButtons = document.getElementById("authButtons")
  if (authButtons) {
    authButtons.innerHTML = `
      <button onclick="openModal('loginModal')" class="btn btn-primary" data-translate="iniciar_sesion">
        Iniciar Sesión
      </button>
      <button onclick="openModal('registerModal')" class="btn btn-outline" data-translate="registrarse">
        Registrarse
      </button>
    `
  }
}

// Update UI for logged in user
function updateUIForLoggedInUser() {
  const authButtons = document.getElementById("authButtons")

  if (authButtons && currentUser) {
    const userInitials = currentUser.nombre.split(' ').map(n => n[0]).join('').toUpperCase();
    const profileImage = currentUser.foto_perfil || null;
    
    authButtons.innerHTML = `
      <div class="user-profile-section">
        <div class="user-avatar">
          ${profileImage ? 
            `<img src="${profileImage}" alt="${currentUser.nombre}" />` : 
            `<div class="user-avatar-placeholder">${userInitials}</div>`
          }
        </div>
        <div class="user-menu">
          <button class="user-menu-button">
            <div class="user-info">
              <span class="user-name">${currentUser.nombre.split(' ')[0]}</span>
              <span class="user-role">${currentUser.tipo_usuario === 'chef' ? 'Chef' : 'Cliente'}</span>
            </div>
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
            </svg>
          </button>
          <div class="user-menu-dropdown">
            ${currentUser.tipo_usuario === 'chef' ? 
              '<a href="dashboard.html">Mi Dashboard</a>' : 
              '<a href="user-profile.html">Mi Perfil</a>'
            }
            <a href="#" onclick="logout()">Cerrar Sesión</a>
          </div>
        </div>
      </div>
    `;
  } else if (authButtons) {
    // Botón de idioma móvil removido para usuarios no logueados
  }
}

// Setup event listeners
function setupEventListeners() {
  // Mobile menu toggle button
  const mobileMenuToggle = document.querySelector('.mobile-menu-toggle')
  if (mobileMenuToggle) {
    mobileMenuToggle.addEventListener('click', (e) => {
      e.preventDefault()
      e.stopPropagation()
      toggleMobileMenu()
    })
  }

  // Search functionality for chefs
  const searchInput = document.getElementById("searchChefs")
  if (searchInput) {
    searchInput.addEventListener("input", debounce(searchChefs, 300))
  }

  // Filter functionality for chefs
  const filterLocation = document.getElementById("filterLocation")
  if (filterLocation) {
    filterLocation.addEventListener("change", searchChefs)
  }

  // Filter functionality for recipes
  const filterPrice = document.getElementById("filterPrice")
  const filterDifficulty = document.getElementById("filterDifficulty")

  if (filterPrice) {
    filterPrice.addEventListener("change", filterRecipes)
  }

  if (filterDifficulty) {
    filterDifficulty.addEventListener("change", filterRecipes)
  }

  // Close mobile menu when navigation links are clicked
  const navLinks = document.querySelectorAll('.nav-container nav a')
  navLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      e.stopPropagation()
      const navContainer = document.querySelector('.nav-container')
      if (navContainer && navContainer.classList.contains('active')) {
        toggleMobileMenu()
      }
    })
  })

  // Close mobile menu when auth buttons are clicked in mobile
  const authButtons = document.querySelectorAll('.nav-container .auth-buttons button')
  authButtons.forEach(button => {
    button.addEventListener('click', (e) => {
      e.stopPropagation()
      const navContainer = document.querySelector('.nav-container')
      if (navContainer && navContainer.classList.contains('active')) {
        toggleMobileMenu()
      }
    })
  })
}

// Initialize animations
function initializeAnimations() {
  // Reveal animations on scroll
  const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px",
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("active")
      }
    })
  }, observerOptions)

  // Observe elements for reveal animation
  document.querySelectorAll(".chef-card, .recipe-card, .section-header").forEach((el) => {
    el.classList.add("reveal")
    observer.observe(el)
  })
}

// Mobile menu toggle function
function toggleMobileMenu() {
  const navContainer = document.querySelector(".nav-container")
  const overlay = document.getElementById("mobileMenuOverlay")
  const menuIcon = document.getElementById("menuIcon")
  const closeIcon = document.getElementById("closeIcon")
  const toggleButton = document.querySelector(".mobile-menu-toggle")

  if (navContainer.classList.contains("active")) {
    // Close menu
    navContainer.classList.remove("active")
    overlay.classList.remove("active")
    toggleButton.classList.remove("active")
    menuIcon.style.display = "inline"
    closeIcon.style.display = "none"
    document.body.style.overflow = "auto"
  } else {
    // Open menu
    navContainer.classList.add("active")
    overlay.classList.add("active")
    toggleButton.classList.add("active")
    menuIcon.style.display = "none"
    closeIcon.style.display = "inline"
    document.body.style.overflow = "hidden"
  }
}

// Mobile menu toggle function for recipe-detail page
function toggleRecipeDetailMobileMenu() {
  const mobileMenu = document.getElementById("mobileMenu")
  const toggleButton = document.querySelector(".mobile-menu-btn")

  if (mobileMenu.classList.contains("active")) {
    // Close menu
    mobileMenu.classList.remove("active")
    toggleButton.classList.remove("active")
    document.body.style.overflow = "auto"
  } else {
    // Open menu
    mobileMenu.classList.add("active")
    toggleButton.classList.add("active")
    document.body.style.overflow = "hidden"
  }
}

// Close mobile menu when overlay is clicked or when clicking outside the menu
document.addEventListener("click", (e) => {
  const overlay = document.getElementById("mobileMenuOverlay")
  const navContainer = document.querySelector(".nav-container")
  const mobileMenuToggle = document.querySelector(".mobile-menu-toggle")
  
  // Only close if clicking on overlay or outside the menu (but not on the toggle button)
  if (overlay && overlay.classList.contains("active")) {
    if (e.target.id === "mobileMenuOverlay" || 
        (!navContainer.contains(e.target) && !mobileMenuToggle.contains(e.target))) {
      toggleMobileMenu()
    }
  }
  
  // Handle recipe-detail mobile menu
  const recipeDetailMobileMenu = document.getElementById("mobileMenu")
  const recipeDetailToggle = document.querySelector(".mobile-menu-btn")
  
  if (recipeDetailMobileMenu && recipeDetailMobileMenu.classList.contains("active")) {
    if (e.target === recipeDetailMobileMenu || 
        (!recipeDetailMobileMenu.querySelector(".mobile-menu-content").contains(e.target) && 
         !recipeDetailToggle.contains(e.target))) {
      toggleRecipeDetailMobileMenu()
    }
  }
})

// Debounce function for search
function debounce(func, wait) {
  let timeout
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout)
      func(...args)
    }
    clearTimeout(timeout)
    timeout = setTimeout(later, wait)
  }
}

// Modal functions
function openModal(modalId) {
  const modal = document.getElementById(modalId)
  if (modal) {
    modal.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId)
  if (modal) {
    modal.classList.add("hidden")
    document.body.style.overflow = "auto"
  }
}

function switchModal(currentModalId, targetModalId) {
  closeModal(currentModalId)
  openModal(targetModalId)
}

function closeBookingModal() {
  closeModal('bookingModal')
  // Reset selected chef and price
  selectedChef = null
  bookingPricePerHour = 0
}

// Smooth scroll to section
function scrollToSection(sectionId) {
  const section = document.getElementById(sectionId)
  if (section) {
    section.scrollIntoView({ behavior: "smooth" })
  }
}

// Authentication functions
async function handleLogin(event) {
  event.preventDefault()
  const formData = new FormData(event.target)

  try {
    showLoading()
    const response = await fetch("api/auth/login.php", {
      method: "POST",
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      // Validate token format before storing
      try {
        const tokenData = JSON.parse(atob(result.token))
        if (!tokenData.user_id || !tokenData.exp) {
          throw new Error('Token inválido')
        }
        
        // Check if token is already expired
        if (tokenData.exp < Math.floor(Date.now() / 1000)) {
          throw new Error('Token expirado')
        }
      } catch (error) {
        showToast("Error en el token de autenticación", "error")
        return
      }
      
      localStorage.setItem("authToken", result.token)
      localStorage.setItem("userData", JSON.stringify(result.user))
      currentUser = result.user

      showToast("Inicio de sesión exitoso", "success")
      closeModal("loginModal")

      // Redirect based on user type
      if (currentUser.tipo_usuario === "chef") {
        setTimeout(() => {
          window.location.href = "dashboard.html"
        }, 1000)
      } else if (currentUser.tipo_usuario === "cliente") {
        setTimeout(() => {
          window.location.href = "user-profile.html"
        }, 1000)
      } else {
        updateUIForLoggedInUser()
      }
    } else {
      showToast(result.message || "Error al iniciar sesión", "error")
    }
  } catch (error) {
    console.error("Login error:", error)
    showToast("Error de conexión", "error")
  } finally {
      hideLoading()
    }
}

async function handleRegister(event) {
  event.preventDefault()
  const formData = new FormData(event.target)

  try {
    showLoading()
    const response = await fetch("api/auth/register.php", {
      method: "POST",
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      showToast("Registro exitoso. Por favor inicia sesión.", "success")
      closeModal("registerModal")
      openModal("loginModal")
    } else {
      showToast(result.message || "Error al registrarse", "error")
    }
  } catch (error) {
    console.error("Register error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
    isSubmittingBooking = false
  }
}

function logout() {
  clearSession()
  showToast("Sesión cerrada exitosamente", "info")
  
  // Only redirect if not already on index page
  if (window.location.pathname !== '/index.html' && !window.location.pathname.endsWith('/')) {
    window.location.href = "index.html"
  }
}

// Load chefs data
async function loadChefs() {
  try {
    const currentLang = window.currentLanguage || 'es'
    const response = await fetch(`api/chefs/list.php?language=${currentLang}`)
    const result = await response.json()

    if (result.success) {
      // Ordenar chefs por calificación promedio de mayor a menor
      chefs = result.data.sort((a, b) => (b.calificacion_promedio || 0) - (a.calificacion_promedio || 0))
      // Mostrar solo los primeros 4 chefs
      displayChefs(chefs.slice(0, 4))
    } else {
      console.error("Error en la respuesta de chefs:", result.message)
    }
  } catch (error) {
    console.error("Error loading chefs:", error)
  }
}

// Display chefs
function displayChefs(chefsToShow) {
  const chefsGrid = document.getElementById("chefsGrid")
  if (!chefsGrid) return

  if (chefsToShow.length === 0) {
    chefsGrid.innerHTML =
      '<p class="text-center col-span-full" style="color: var(--text-light);">No se encontraron chefs.</p>'
    return
  }

  chefsGrid.innerHTML = chefsToShow
    .map(
      (chef) => `
        <div class="chef-card">
            <div class="chef-image">
                <img src="${chef.foto_perfil || "/placeholder.svg?height=350&width=300"}" 
                     alt="Chef ${chef.nombre}">
                <div class="chef-overlay">
                    <button onclick="viewChefProfile(${chef.id})" class="btn btn-light">
                        Ver Perfil
                    </button>
                </div>
            </div>
            <div class="chef-info">
                <h3>${chef.nombre}</h3>
                <div class="chef-title">${chef.especialidad}</div>
                <p class="specialty">${chef.biografia || "Chef profesional con experiencia en alta cocina"}</p>
                
                <div class="chef-meta">
                    <div class="rating">
                        <div class="stars">
                            ${generateStars(chef.calificacion_promedio)}
                        </div>
                        <div class="reviews">(${chef.total_servicios} servicios)</div>
                    </div>
                    <div class="chef-location">${chef.ubicacion}</div>
                </div>
                
                <div class="mt-4 flex gap-2">
                    <button onclick="viewChefProfile(${chef.id})" class="btn btn-primary flex-1">
                        Ver Perfil
                    </button>
                    <button onclick="contactChef(${chef.id})" class="btn btn-outline flex-1">
                        Contactar
                    </button>
                </div>
            </div>
        </div>
    `,
    )
    .join("")
}

// Generate star rating HTML
function generateStars(rating) {
  const fullStars = Math.floor(rating)
  const hasHalfStar = rating % 1 !== 0
  const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0)

  let starsHTML = ""

  // Full stars
  for (let i = 0; i < fullStars; i++) {
    starsHTML += '<span class="star">★</span>'
  }

  // Half star
  if (hasHalfStar) {
    starsHTML += '<span class="star">☆</span>'
  }

  // Empty stars
  for (let i = 0; i < emptyStars; i++) {
    starsHTML += '<span class="star empty">☆</span>'
  }

  return starsHTML
}

// View chef profile
function viewChefProfile(chefId) {
  window.location.href = `chef-profile.html?id=${chefId}`;
}

// Search chefs
function searchChefs() {
  const searchTerm = document.getElementById("searchChefs")?.value.toLowerCase() || ""
  const locationFilter = document.getElementById("filterLocation")?.value || ""

  const filteredChefs = chefs.filter((chef) => {
    const matchesSearch =
      chef.especialidad.toLowerCase().includes(searchTerm) || chef.nombre.toLowerCase().includes(searchTerm)
    const matchesLocation = !locationFilter || chef.ubicacion === locationFilter

    return matchesSearch && matchesLocation
  })

  // Ordenar por calificación y mostrar solo los 4 mejores
  const topChefs = filteredChefs
    .sort((a, b) => (b.calificacion_promedio || 0) - (a.calificacion_promedio || 0))
    .slice(0, 4)

  displayChefs(topChefs)
}

// Load recipes data
async function loadRecipes() {
  try {
    const currentLang = window.currentLanguage || 'es'
    const response = await fetch(`api/recipes/list.php?language=${currentLang}`)
    const result = await response.json()

    if (result.success) {
      // Ordenar recetas por calificación promedio de mayor a menor
      recipes = result.data.sort((a, b) => (b.calificacion_promedio || 0) - (a.calificacion_promedio || 0))
      // Mostrar solo las primeras 4 recetas
      displayRecipes(recipes.slice(0, 4))
    } else {
      console.error("Error en la respuesta de recetas:", result.message)
    }
  } catch (error) {
    console.error("Error loading recipes:", error)
  }
}

// Función para filtrar recetas
function filterRecipes() {
  const priceFilter = document.getElementById("filterPrice")?.value || ""
  const difficultyFilter = document.getElementById("filterDifficulty")?.value || ""

  const filteredRecipes = recipes.filter((recipe) => {
    const matchesPrice = !priceFilter || 
      (priceFilter === "low" && recipe.precio <= 20) ||
      (priceFilter === "medium" && recipe.precio > 20 && recipe.precio <= 50) ||
      (priceFilter === "high" && recipe.precio > 50)

    const matchesDifficulty = !difficultyFilter || recipe.dificultad === difficultyFilter

    return matchesPrice && matchesDifficulty
  })

  // Ordenar por calificación y mostrar solo las 4 mejores
  const topRecipes = filteredRecipes
    .sort((a, b) => (b.calificacion_promedio || 0) - (a.calificacion_promedio || 0))
    .slice(0, 4)

  displayRecipes(topRecipes)
}

// Display recipes
function displayRecipes(recipesToShow) {
  const recetasGrid = document.getElementById("recetasGrid")
  if (!recetasGrid) return

  if (recipesToShow.length === 0) {
    recetasGrid.innerHTML =
      '<p class="text-center col-span-full" style="color: var(--text-light);">No se encontraron recetas.</p>'
    return
  }

  recetasGrid.innerHTML = recipesToShow
    .map(
      (recipe) => `
        <div class="recipe-card">
            <div class="recipe-image">
                <img src="${recipe.imagen || "/placeholder.svg?height=220&width=300"}" 
                     alt="${recipe.titulo}">
                <div class="recipe-badge">${recipe.dificultad}</div>
            </div>
            <div class="recipe-info">
                <div class="recipe-category">Por ${recipe.chef_nombre}</div>
                <h3>${recipe.titulo}</h3>
                <p class="chef">${recipe.descripcion || "Receta deliciosa y fácil de preparar"}</p>
                
                <div class="recipe-meta">
                    <span>⏱️ ${recipe.tiempo_preparacion} min</span>
                    <span class="accent-text font-bold">$${recipe.precio}</span>
                </div>
                
                <button onclick="viewRecipe(${recipe.id})" class="btn btn-primary btn-block">
                    Ver Receta
                </button>
            </div>
        </div>
    `,
    )
    .join("")
}

// Chef profile functions

function contactChef(chefId) {
  if (!currentUser) {
    showToast("Debes iniciar sesión para contactar un chef", "warning")
    openModal("loginModal")
    return
  }

  // Abrir modal de reserva directamente
  openBookingModal(chefId)
}

// Recipe functions
function viewRecipe(recipeId) {
  // Check if user is authenticated
  if (!currentUser) {
    showToast("Debes iniciar sesión para ver los detalles de las recetas", "warning")
    openModal("loginModal")
    return
  }
  
  // Load recipe data and show modal
  loadRecipeModal(recipeId)
}

// Load recipe data for modal
async function loadRecipeModal(recipeId) {
  try {
    showLoading()
    
    const currentLang = window.currentLanguage || 'es'
    const response = await fetch(`api/recipes/list.php?id=${recipeId}&language=${currentLang}`)
    const result = await response.json()
    
    if (result.success && result.data.length > 0) {
      const recipe = result.data[0]
      populateRecipeModal(recipe)
      openModal("recipeModal")
    } else {
      showToast("No se pudo cargar la información de la receta", "error")
    }
  } catch (error) {
    console.error("Error loading recipe:", error)
    showToast("Error al cargar los datos de la receta", "error")
  } finally {
    hideLoading()
  }
}

// Populate recipe modal with data
function populateRecipeModal(recipe) {
  document.getElementById("modalRecipeTitle").textContent = recipe.titulo
  document.getElementById("modalRecipeChef").textContent = `Por ${recipe.chef_nombre}`
  document.getElementById("modalRecipeTime").textContent = `${recipe.tiempo_preparacion} min`
  document.getElementById("modalRecipeDifficulty").textContent = recipe.dificultad
  document.getElementById("modalRecipePrice").textContent = `$${recipe.precio}`
  document.getElementById("modalRecipeDescription").textContent = recipe.descripcion || "No hay descripción disponible."
  
  // Set image
  const modalImage = document.getElementById("modalRecipeImage")
  modalImage.src = recipe.imagen || "/placeholder.svg?height=300&width=400"
  modalImage.alt = recipe.titulo
  
  // Parse and display ingredients
  const ingredientsList = document.getElementById("modalRecipeIngredients")
  if (recipe.ingredientes) {
    const ingredients = recipe.ingredientes.split('\n').filter(ing => ing.trim())
    if (ingredients.length > 0) {
      ingredientsList.innerHTML = ingredients
        .map(ingredient => `<li>${ingredient.trim()}</li>`)
        .join('')
    } else {
      ingredientsList.innerHTML = '<li>No hay ingredientes disponibles</li>'
    }
  } else {
    ingredientsList.innerHTML = '<li>No hay ingredientes disponibles</li>'
  }
  
  // Parse and display instructions
  const instructionsList = document.getElementById("modalRecipeInstructions")
  if (recipe.instrucciones) {
    const instructions = recipe.instrucciones.split('\n').filter(inst => inst.trim())
    if (instructions.length > 0) {
      instructionsList.innerHTML = instructions
        .map((instruction, index) => `<li>${instruction.trim()}</li>`)
        .join('')
    } else {
      instructionsList.innerHTML = '<li>No hay instrucciones disponibles</li>'
    }
  } else {
    instructionsList.innerHTML = '<li>No hay instrucciones disponibles</li>'
  }
  
  // Setup modal buttons
  const buyBtn = document.getElementById("modalBuyRecipeBtn")
  const favBtn = document.getElementById("modalAddToFavoritesBtn")
  const detailBtn = document.getElementById("modalViewDetailBtn")
  
  buyBtn.onclick = () => buyRecipe(recipe.id)
  favBtn.onclick = () => toggleFavoriteRecipe(recipe.id)
  detailBtn.onclick = () => viewRecipeDetail(recipe.id)
}

// Buy recipe function
function buyRecipe(recipeId) {
  if (!currentUser) {
    showToast("Debes iniciar sesión para comprar recetas", "warning")
    return
  }
  
  // Implement buy recipe logic here
  showToast("Funcionalidad de compra en desarrollo", "info")
}

// Toggle favorite recipe function
function toggleFavoriteRecipe(recipeId) {
  if (!currentUser) {
    showToast("Debes iniciar sesión para agregar favoritos", "warning")
    return
  }
  
  if (currentUser.tipo_usuario !== 'cliente') {
    showToast("Solo los clientes pueden añadir recetas a favoritos", "warning")
    return
  }
  
  addToFavoritesAPI('recipe', recipeId)
}

// Navigate to recipe detail page
function viewRecipeDetail(recipeId) {
  if (!currentUser) {
    showToast("Debes iniciar sesión para ver los detalles de las recetas", "warning")
    return
  }
  
  // Store recipe ID for the detail page
  localStorage.setItem("selectedRecipeId", recipeId)
  
  // Close modal and navigate to detail page
  closeModal("recipeModal")
  window.location.href = `recipe-detail.html?id=${recipeId}`
}

// Generic function to add to favorites via API
async function addToFavoritesAPI(type, id) {
  try {
    const response = await fetch('api/client/add-favorite.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      },
      body: JSON.stringify({ type, id })
    })
    
    const result = await response.json()
    
    if (result.success) {
      showToast(result.message || `${type === 'chef' ? 'Chef' : 'Receta'} añadido a favoritos`, 'success')
    } else {
      showToast(result.message || 'Error al añadir a favoritos', 'error')
    }
  } catch (error) {
    console.error('Error adding to favorites:', error)
    showToast('Error de conexión', 'error')
  }
}

// Utility functions
function showToast(message, type = "info") {
  const toast = document.createElement("div")
  toast.className = `toast ${type}`
  toast.textContent = message

  document.body.appendChild(toast)

  setTimeout(() => {
    toast.classList.add("show")
  }, 100)

  setTimeout(() => {
    toast.classList.remove("show")
    setTimeout(() => {
      document.body.removeChild(toast)
    }, 300)
  }, 3000)
}

function showLoading() {
  const loader = document.createElement("div")
  loader.id = "globalLoader"
  loader.className = "fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
  loader.innerHTML = '<div class="loading-spinner"></div>'
  document.body.appendChild(loader)
}

function hideLoading() {
  const loader = document.getElementById("globalLoader")
  if (loader) {
    document.body.removeChild(loader)
  }
}

function formatCurrency(amount) {
  return new Intl.NumberFormat("es-SV", {
    style: "currency",
    currency: "USD",
  }).format(amount)
}

function formatDate(dateString) {
  return new Intl.DateTimeFormat("es-SV", {
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(new Date(dateString))
}

function validateEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return re.test(email)
}

function validatePhone(phone) {
  const re = /^\d{4}-\d{4}$/
  return re.test(phone)
}

// URL Routing Handler
function handleUrlRouting() {
  const hash = window.location.hash
  
  if (hash.startsWith('#booking')) {
    const urlParams = new URLSearchParams(hash.split('?')[1])
    const chefId = urlParams.get('chef')
    
    if (chefId) {
      if (!currentUser) {
        showToast("Debes iniciar sesión para hacer una reserva", "warning")
        openModal("loginModal")
        return
      }
      openBookingModal(chefId)
    }
  }
}

// Listen for hash changes
window.addEventListener('hashchange', handleUrlRouting)

// Booking Modal Functions
let selectedChef = null
let bookingPricePerHour = 0
let isSubmittingBooking = false

async function openBookingModal(chefId) {
  try {
    console.log('Abriendo modal de reserva para chef ID:', chefId)
    
    // Validar que se proporcione un ID válido
    if (!chefId || chefId === 'undefined' || chefId === 'null') {
      console.error('Error: ID de chef inválido:', chefId)
      showToast('Error: ID de chef no válido', 'error')
      return
    }
    
    showLoading()
    
    // Verificar autenticación
    const token = localStorage.getItem('authToken')
    if (!token) {
      console.error('Error: Token de autenticación no encontrado')
      showToast('Debes iniciar sesión para hacer una reserva', 'warning')
      openModal('loginModal')
      return
    }
    
    // Fetch chef details
    const apiUrl = `api/chefs/profile-complete.php?chef_id=${chefId}`
    console.log('Consultando API:', apiUrl)
    
    const response = await fetch(apiUrl, {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })
    
    console.log('Respuesta HTTP status:', response.status)
    
    if (!response.ok) {
      throw new Error(`Error HTTP: ${response.status} ${response.statusText}`)
    }
    
    const data = await response.json()
    console.log('Respuesta de la API:', data)
    
    if (data.success) {
      selectedChef = data.data.profile
      selectedChef.id = data.data.id
      bookingPricePerHour = parseFloat(selectedChef.precio_por_hora || 0)
      
      console.log('Chef seleccionado:', selectedChef)
      console.log('Precio por hora:', bookingPricePerHour)
      
      // Verificar que el chef tenga datos válidos
      if (!selectedChef.id || !selectedChef.nombre) {
        console.error('Error: Información del chef incompleta:', selectedChef)
        showToast('Error: Información del chef incompleta', 'error')
        return
      }
      
      if (bookingPricePerHour <= 0) {
        console.error('Error: Precio por hora no válido:', bookingPricePerHour)
        showToast('Error: El chef no tiene precio por hora configurado', 'error')
        return
      }
      
      // Update modal content
      const bookingChefNameElement = document.getElementById('bookingChefName')
      if (bookingChefNameElement) {
        bookingChefNameElement.textContent = selectedChef.nombre
      }
      
      // Reset form
      const bookingForm = document.getElementById('bookingForm')
      if (bookingForm) {
        bookingForm.reset()
      }
      
      updateBookingPrice()
      
      // Add event listeners for price updates
      const durationElement = document.getElementById('duracionServicio')
      const dinersElement = document.getElementById('numeroComensales')
      
      if (durationElement) {
        durationElement.removeEventListener('input', updateBookingPrice)
        durationElement.addEventListener('input', updateBookingPrice)
      }
      if (dinersElement) {
        dinersElement.removeEventListener('change', updateBookingPrice)
        dinersElement.addEventListener('change', updateBookingPrice)
      }
      
      console.log('Abriendo modal de reserva')
      openModal('bookingModal')
    } else {
      console.error('Error en la respuesta de la API:', data.message)
      showToast(data.message || 'Error al cargar información del chef', 'error')
    }
  } catch (error) {
    console.error('Error opening booking modal:', error)
    showToast(`Error al cargar información del chef: ${error.message}`, 'error')
  } finally {
    hideLoading()
  }
}

function updateBookingPrice() {
  const durationElement = document.getElementById('duracionServicio')
  const dinersElement = document.getElementById('numeroComensales')
  
  const duration = durationElement ? parseFloat(durationElement.value) || 0 : 0
  const diners = dinersElement ? parseInt(dinersElement.value) || 1 : 1
  
  const subtotal = bookingPricePerHour * duration
  const total = subtotal
  
  // Update hourly rate display
  const hourlyRateElement = document.getElementById('chefHourlyRate')
  if (hourlyRateElement) {
    hourlyRateElement.textContent = formatCurrency(bookingPricePerHour)
  }
  
  // Update duration display
  const serviceDurationElement = document.getElementById('serviceDuration')
  if (serviceDurationElement) {
    serviceDurationElement.textContent = `${duration} horas`
  }
  
  // Update total price
  const totalPriceElement = document.getElementById('totalPrice')
  if (totalPriceElement) {
    totalPriceElement.textContent = formatCurrency(total)
  }
}

async function handleBookingSubmission(event) {
  event.preventDefault()
  
  // Prevenir envíos múltiples
  if (isSubmittingBooking) {
    console.log('Ya se está procesando una solicitud de reserva')
    return
  }
  
  if (!selectedChef || !selectedChef.id) {
    showToast('Error: No se ha seleccionado un chef válido', 'error')
    return
  }
  
  // Verificar que el chef tenga precio por hora
  if (!selectedChef.precio_por_hora || selectedChef.precio_por_hora <= 0) {
    showToast('Error: El chef seleccionado no tiene precio configurado', 'error')
    return
  }
  
  // Marcar como enviando
  isSubmittingBooking = true
  
  const formData = new FormData(event.target)
  const bookingData = {
    chef_id: selectedChef.id,
    fecha_servicio: formData.get('fecha_servicio'),
    hora_servicio: formData.get('hora_servicio'),
    numero_comensales: parseInt(formData.get('numero_comensales')),
    duracion_estimada: parseFloat(formData.get('duracion_servicio')),
    ubicacion_servicio: formData.get('ubicacion_servicio'),
    descripcion_evento: formData.get('descripcion_evento')
  }
  
  // Log para debugging
  console.log('Datos del formulario de reserva:', bookingData)
  console.log('Chef seleccionado:', selectedChef)
  
  // Validation
  if (!bookingData.fecha_servicio || !bookingData.hora_servicio || !bookingData.ubicacion_servicio) {
    showToast('Por favor completa todos los campos requeridos', 'warning')
    return
  }
  
  // Validar duración del servicio
  if (!bookingData.duracion_estimada || bookingData.duracion_estimada <= 0) {
    showToast('Por favor selecciona la duración del servicio', 'warning')
    return
  }
  
  // Validar número de comensales
  if (!bookingData.numero_comensales) {
    showToast('Por favor selecciona el número de comensales', 'warning')
    return
  }
  
  // Check if date is in the future
  const serviceDateTime = new Date(`${bookingData.fecha_servicio}T${bookingData.hora_servicio}`)
  if (serviceDateTime <= new Date()) {
    showToast('La fecha y hora del servicio debe ser en el futuro', 'warning')
    return
  }
  
  try {
    showLoading()
    
    console.log('Enviando datos al servidor:', bookingData)
    console.log('Token de autenticación:', localStorage.getItem('authToken'))
    
    const response = await fetch('api/services/create.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      },
      body: JSON.stringify(bookingData)
    })
    
    console.log('Respuesta HTTP status:', response.status)
    console.log('Respuesta headers:', response.headers)
    
    const data = await response.json()
    console.log('Respuesta del servidor:', data)
    
    if (data.success) {
      showToast('¡Reserva creada exitosamente!', 'success')
      closeModal('bookingModal')
      
      // Clear URL hash
      window.location.hash = ''
      
      // Optionally redirect to user profile or reservations
      setTimeout(() => {
        window.location.href = 'user-profile.html'
      }, 2000)
    } else {
      console.error('Error del servidor:', data.message)
      showToast(data.message || 'Error al crear la reserva', 'error')
    }
  } catch (error) {
    console.error('Error creating booking:', error)
    showToast('Error al crear la reserva: ' + error.message, 'error')
  } finally {
    hideLoading()
  }
}
