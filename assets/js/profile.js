// JavaScript para la página de perfil de usuario

// Variables globales
// currentUser is declared globally in main.js
let userPreferences = []
let favoriteChefs = []
let favoriteRecipes = []
let userReviews = []
let profileConversations = []
let currentProfileConversation = null

// Inicializar la página
document.addEventListener("DOMContentLoaded", async () => {
  await checkAuthStatus()
  setupEventListeners()
  
  // Configurar navegación entre tabs
  document.querySelectorAll('.profile-nav-item').forEach(item => {
    item.addEventListener('click', function() {
      const tabId = this.getAttribute('data-tab')
      showTab(tabId)
    })
  })
  
  // Configurar formularios
  const profileForm = document.getElementById('profileForm')
  if (profileForm) {
    profileForm.addEventListener('submit', updateProfile)
  }
  
  const preferencesForm = document.getElementById('preferencesForm')
  if (preferencesForm) {
    preferencesForm.addEventListener('submit', updatePreferences)
  }
  
  // Configurar botón para añadir preferencias
  const addPrefButton = document.getElementById('addPreferenceBtn')
  if (addPrefButton) {
    addPrefButton.addEventListener('click', addPreference)
  }
  
  // Cargar servicios completados
  loadCompletedServices()
  
  // Inicializar funcionalidad de estrellas
  initializeStarRating()
  
  // Cerrar modal al hacer clic fuera de él
  const reviewModal = document.getElementById('reviewModal')
  if (reviewModal) {
    reviewModal.addEventListener('click', function(e) {
      if (e.target === this) {
        closeReviewModal()
      }
    })
  }
})

// Verificar si el usuario está autenticado
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

      if (!result.success) {
        // Token is invalid, redirect to index
        localStorage.removeItem("authToken")
        localStorage.removeItem("userData")
        window.location.href = "index.html"
        return
      }
    } catch (error) {
      console.error("Error validating token:", error)
      // On network error, continue but user might face issues with API calls
    }
    
    currentUser = JSON.parse(userData)
    
    // Verificar si el usuario es cliente
    if (currentUser.tipo_usuario !== "cliente") {
      // Redirigir a la página principal si no es cliente
      window.location.href = "index.html"
      return
    }
    
    updateUIForLoggedInUser()
    loadUserProfile()
    loadUserPreferences()
    loadFavoriteChefs()
    loadFavoriteRecipes()
    loadUserReviews()
  } else {
    // Redirigir a la página principal si no hay sesión
    window.location.href = "index.html"
  }
}

// Actualizar UI para usuario con sesión
function updateUIForLoggedInUser() {
  const authButtons = document.getElementById("authButtons")
  const userName = document.getElementById("userName")
  const userEmail = document.getElementById("userEmail")

  if (authButtons && currentUser) {
    authButtons.innerHTML = `
      <div class="flex items-center space-x-4">
        <span class="font-medium">Hola, ${currentUser.nombre}</span>
        <a href="user-profile.html" class="btn btn-primary">
          Mi Perfil
        </a>
        <button onclick="logout()" class="btn btn-outline-sm text-red-600 hover:text-red-800">
          Cerrar Sesión
        </button>
      </div>
    `
  }
  
  // Actualizar nombre y email en el sidebar
  if (userName && currentUser) {
    userName.textContent = currentUser.nombre
  }
  
  if (userEmail && currentUser) {
    userEmail.textContent = currentUser.email
  }
}

// Configurar event listeners
function setupEventListeners() {
  // Manejar cambio de foto de perfil
  const fotoPerfilInput = document.getElementById("foto_perfil")
  if (fotoPerfilInput) {
    fotoPerfilInput.addEventListener("change", previewProfileImage)
  }
  
  // Configurar navegación entre tabs
  document.querySelectorAll('.profile-nav-item').forEach(item => {
    item.addEventListener('click', function() {
      const tabId = this.getAttribute('data-tab')
      showTab(tabId)
    })
  })
  
  // Configurar input de nueva preferencia para manejar Enter
  const newPrefInput = document.getElementById("newPreference")
  if (newPrefInput) {
    newPrefInput.addEventListener('keypress', function(event) {
      if (event.key === 'Enter') {
        event.preventDefault()
        addPreference()
      }
    })
  }
  
  // Configurar input de mensajes del perfil para manejar Enter
  const profileMessageInput = document.getElementById("profileMessageInput")
  if (profileMessageInput) {
    profileMessageInput.addEventListener('keypress', function(event) {
      if (event.key === 'Enter') {
        event.preventDefault()
        sendProfileMessage()
      }
    })
  }
}

// Previsualizar imagen de perfil
function previewProfileImage(event) {
  const file = event.target.files[0]
  if (file) {
    const reader = new FileReader()
    reader.onload = function(e) {
      document.getElementById("profileImage").src = e.target.result
    }
    reader.readAsDataURL(file)
  }
}

// Cargar perfil del usuario
async function loadUserProfile() {
  try {
    // Mostrar indicador de carga
    showLoading()

    const response = await fetch("api/profile/get.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      const profile = result.data
      
      // Actualizar información en la UI
      document.getElementById("userName").textContent = profile.nombre
      document.getElementById("userEmail").textContent = profile.email
      
      // Actualizar foto de perfil si existe
      if (profile.foto_perfil) {
        document.getElementById("profileImage").src = profile.foto_perfil
        
        // También actualizar foto en la barra lateral si existe
        const sidebarProfilePic = document.getElementById("sidebarProfilePic")
        if (sidebarProfilePic) {
          sidebarProfilePic.src = profile.foto_perfil
        }
      }
      
      // Llenar formulario de perfil
      document.getElementById("nombre").value = profile.nombre || ""
      document.getElementById("email").value = profile.email || ""
      document.getElementById("telefono").value = profile.telefono || ""
      // Campos direccion y fecha_nacimiento eliminados - no se utilizan en la aplicación
    }
  } catch (error) {
    console.error("Error loading profile:", error)
    showToast("Error al cargar el perfil. Por favor, intenta de nuevo más tarde.", "error")
  } finally {
    hideLoading()
  }
}

// Cargar preferencias del usuario
async function loadUserPreferences() {
  try {
    const response = await fetch("api/client/preferences.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      // Filtrar solo las preferencias personalizadas para mostrar en la lista
      userPreferences = result.data.filter(pref => pref.tipo === 'custom')
      displayUserPreferences()
      
      // Marcar checkboxes de tipos de cocina y restricciones
      if (result.cuisine_types) {
        result.cuisine_types.forEach(type => {
          const checkbox = document.querySelector(`input[name="cuisine_type[]"][value="${type}"]`)
          if (checkbox) checkbox.checked = true
        })
      }
      
      if (result.dietary_restrictions) {
        result.dietary_restrictions.forEach(restriction => {
          const checkbox = document.querySelector(`input[name="dietary_restrictions[]"][value="${restriction}"]`)
          if (checkbox) checkbox.checked = true
        })
      }
    }
  } catch (error) {
    console.error("Error loading preferences:", error)
    showToast("Error al cargar preferencias", "error")
  }
}

// Mostrar preferencias del usuario
function displayUserPreferences() {
  const preferencesContainer = document.getElementById("userPreferences")
  if (!preferencesContainer) return

  if (userPreferences.length === 0) {
    preferencesContainer.innerHTML = '<p class="text-gray-500">No has añadido preferencias aún.</p>'
    return
  }

  preferencesContainer.innerHTML = userPreferences
    .map(
      (pref) => `
        <div class="preference-tag">
            ${pref.preferencia}
            <button type="button" onclick="removePreference('${pref.id}')" class="preference-remove">
                &times;
            </button>
        </div>
      `
    )
    .join("")
}

// Añadir nueva preferencia
async function addPreference() {
  const newPrefInput = document.getElementById("newPreference")
  const preference = newPrefInput.value.trim()
  
  if (!preference) {
    showToast("Por favor ingresa una preferencia", "warning")
    return
  }
  
  // Verificar si la preferencia ya existe
  if (userPreferences.some(pref => pref.preferencia.toLowerCase() === preference.toLowerCase())) {
    showToast("Esta preferencia ya existe", "warning")
    return
  }
  
  try {
    showLoading()
    
    // Crear FormData con todas las preferencias actuales más la nueva
    const formData = new FormData()
    
    // Añadir preferencias existentes
    userPreferences.forEach((pref, index) => {
      formData.append(`preferences[${index}]`, pref.preferencia)
    })
    
    // Añadir nueva preferencia
    formData.append(`preferences[${userPreferences.length}]`, preference)
    
    // Mantener tipos de cocina y restricciones seleccionadas
    const cuisineCheckboxes = document.querySelectorAll('input[name="cuisine_type[]"]:checked')
    cuisineCheckboxes.forEach(checkbox => {
      formData.append('cuisine_type[]', checkbox.value)
    })
    
    const restrictionCheckboxes = document.querySelectorAll('input[name="dietary_restrictions[]"]:checked')
    restrictionCheckboxes.forEach(checkbox => {
      formData.append('dietary_restrictions[]', checkbox.value)
    })
    
    const response = await fetch("api/client/update-preferences.php", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      // Añadir a la lista local
      const tempId = Date.now().toString()
      userPreferences.push({ id: tempId, preferencia: preference, tipo: 'custom' })
      displayUserPreferences()
      
      // Limpiar input
      newPrefInput.value = ""
      
      showToast("Preferencia añadida exitosamente", "success")
    } else {
      showToast(result.message || "Error al añadir preferencia", "error")
    }
  } catch (error) {
    console.error("Add preference error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Eliminar preferencia
async function removePreference(prefId) {
  try {
    showLoading()
    
    // Filtrar la preferencia a eliminar
    const updatedPreferences = userPreferences.filter(pref => pref.id !== prefId)
    
    // Crear FormData con las preferencias restantes
    const formData = new FormData()
    
    // Añadir preferencias restantes
    updatedPreferences.forEach((pref, index) => {
      formData.append(`preferences[${index}]`, pref.preferencia)
    })
    
    // Mantener tipos de cocina y restricciones seleccionadas
    const cuisineCheckboxes = document.querySelectorAll('input[name="cuisine_type[]"]:checked')
    cuisineCheckboxes.forEach(checkbox => {
      formData.append('cuisine_type[]', checkbox.value)
    })
    
    const restrictionCheckboxes = document.querySelectorAll('input[name="dietary_restrictions[]"]:checked')
    restrictionCheckboxes.forEach(checkbox => {
      formData.append('dietary_restrictions[]', checkbox.value)
    })
    
    const response = await fetch("api/client/update-preferences.php", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      // Actualizar lista local
      userPreferences = updatedPreferences
      displayUserPreferences()
      
      showToast("Preferencia eliminada exitosamente", "success")
    } else {
      showToast(result.message || "Error al eliminar preferencia", "error")
    }
  } catch (error) {
    console.error("Remove preference error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Cargar chefs favoritos
async function loadFavoriteChefs() {
  try {
    const response = await fetch("api/client/favorites.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      favoriteChefs = result.data
      displayFavoriteChefs()
    }
  } catch (error) {
    console.error("Error loading favorite chefs:", error)
    showToast("Error al cargar chefs favoritos", "error")
  }
}

// Mostrar chefs favoritos
function displayFavoriteChefs() {
  const chefsContainer = document.getElementById("favoriteChefs")
  if (!chefsContainer) return

  if (favoriteChefs.length === 0) {
    chefsContainer.innerHTML = '<p class="text-gray-500 col-span-full text-center">No tienes chefs favoritos.</p>'
    return
  }

  chefsContainer.innerHTML = favoriteChefs
    .map(
      (chef) => `
        <div class="favorite-card">
            <div class="favorite-image">
                <img src="${chef.foto_perfil || "/placeholder.svg?height=100&width=100"}" 
                     alt="Chef ${chef.nombre}">
            </div>
            <div class="favorite-info">
                <h4>${chef.nombre}</h4>
                <p>${chef.especialidad || "Chef Profesional"}</p>
                <div class="favorite-rating">
                    <span class="stars">${generateStars(chef.calificacion_promedio)}</span>
                    <span class="rating-value">${chef.calificacion_promedio || "N/A"}</span>
                </div>
                <div class="favorite-actions">
                    <button onclick="viewChefProfile(${chef.id})" class="btn btn-sm btn-outline">
                        Ver Perfil
                    </button>
                    <button onclick="removeFromFavorites('chef', ${chef.id})" class="btn btn-sm btn-danger">
                        Eliminar
                    </button>
                </div>
            </div>
        </div>
      `
    )
    .join("")
}

// Cargar recetas favoritas
async function loadFavoriteRecipes() {
  try {
    const response = await fetch("api/client/favorite-recipes.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      favoriteRecipes = result.data
      displayFavoriteRecipes()
    }
  } catch (error) {
    console.error("Error loading favorite recipes:", error)
    showToast("Error al cargar recetas favoritas", "error")
  }
}

// Mostrar recetas favoritas
function displayFavoriteRecipes() {
  const recipesContainer = document.getElementById("favoriteRecipes")
  if (!recipesContainer) return

  if (favoriteRecipes.length === 0) {
    recipesContainer.innerHTML = '<p class="text-gray-500 col-span-full text-center">No tienes recetas favoritas.</p>'
    return
  }

  recipesContainer.innerHTML = favoriteRecipes
    .map(
      (recipe) => `
        <div class="favorite-card">
            <div class="favorite-image">
                <img src="${recipe.imagen || "/placeholder.svg?height=100&width=100"}" 
                     alt="${recipe.titulo}">
            </div>
            <div class="favorite-info">
                <h4>${recipe.titulo}</h4>
                <p>Chef: ${recipe.chef_nombre}</p>
                <div class="favorite-price">
                    $${recipe.precio ? parseFloat(recipe.precio).toFixed(2) : "N/A"}
                </div>
                <div class="favorite-actions">
                    <button onclick="viewRecipe(${recipe.id})" class="btn btn-sm btn-outline">
                        Ver Receta
                    </button>
                    <button onclick="removeFromFavorites('recipe', ${recipe.id})" class="btn btn-sm btn-danger">
                        Eliminar
                    </button>
                </div>
            </div>
        </div>
      `
    )
    .join("")
}

// Cargar servicios completados
async function loadCompletedServices() {
  try {
    const response = await fetch("api/client/completed-services.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      completedServices = result.data
      displayCompletedServices()
    }
  } catch (error) {
    console.error("Error loading completed services:", error)
    showToast("Error al cargar servicios", "error")
  }
}

// Mostrar servicios completados
function displayCompletedServices() {
  console.log('displayCompletedServices called with:', completedServices)
  
  const servicesContainer = document.getElementById("completedServices")
  if (!servicesContainer) {
    console.error('completedServices container not found')
    return
  }

  if (completedServices.length === 0) {
    servicesContainer.innerHTML = '<p class="text-gray-500 text-center">No tienes servicios completados aún.</p>'
    return
  }

  const servicesHTML = completedServices
    .map(
      (service) => {
        const buttonHTML = !service.ya_calificado ? 
          `<button onclick="openReviewModal(${service.id}, '${service.chef_nombre}')" class="btn btn-primary">
            Calificar Servicio
          </button>` : 
          `<span class="text-gray-500">Ya has calificado este servicio</span>`
        
        console.log(`Service ${service.id} button HTML:`, buttonHTML)
        
        return `
        <div class="service-card">
            <div class="service-header">
                <div class="service-info">
                    <h4>Chef ${service.chef_nombre}</h4>
                    <div class="service-date">${formatDate(service.fecha_servicio)} - ${service.hora_servicio}</div>
                    <div class="service-location">${service.ubicacion_servicio}</div>
                </div>
                <div class="service-status ${service.ya_calificado ? 'reviewed' : 'completed'}">
                    ${service.ya_calificado ? 'Calificado' : 'Completado'}
                </div>
            </div>
            <div class="service-details">
                <p><strong>Comensales:</strong> ${service.numero_comensales}</p>
                <p><strong>Precio:</strong> $${parseFloat(service.precio_total).toFixed(2)}</p>
                ${service.descripcion_evento ? `<p><strong>Descripción:</strong> ${service.descripcion_evento}</p>` : ''}
            </div>
            <div class="service-actions">
                ${buttonHTML}
            </div>
        </div>
      `
      }
    )
    .join("")
    
  console.log('Generated services HTML:', servicesHTML)
  servicesContainer.innerHTML = servicesHTML
  console.log('Services container updated')
}

// Cargar reseñas del usuario
async function loadUserReviews() {
  try {
    const response = await fetch("api/client/reviews.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      userReviews = result.data
      displayUserReviews()
    }
  } catch (error) {
    console.error("Error loading reviews:", error)
    showToast("Error al cargar reseñas", "error")
  }
}

// Mostrar reseñas del usuario
function displayUserReviews() {
  const reviewsContainer = document.getElementById("userReviews")
  if (!reviewsContainer) return

  if (userReviews.length === 0) {
    reviewsContainer.innerHTML = '<p class="text-gray-500 text-center">No has realizado reseñas aún.</p>'
    return
  }

  reviewsContainer.innerHTML = userReviews
    .map(
      (review) => `
        <div class="review-card">
            <div class="review-header">
                <div>
                    <h4>${review.chef_nombre}</h4>
                    <div class="review-date">${formatDate(review.fecha_calificacion)}</div>
                </div>
                <div class="review-rating">
                    <span class="stars">${generateStars(review.puntuacion)}</span>
                    <span class="rating-value">${review.puntuacion}</span>
                </div>
            </div>
            <div class="review-title">${review.titulo || "Sin título"}</div>
            <div class="review-content">${review.comentario}</div>
            <div class="review-actions">
                <button onclick="editReview(${review.id})" class="btn btn-sm btn-outline">
                    Editar
                </button>
                <button onclick="deleteReview(${review.id})" class="btn btn-sm btn-danger">
                    Eliminar
                </button>
            </div>
        </div>
      `
    )
    .join("")
}

// Actualizar perfil
async function updateProfile(event) {
  event.preventDefault()
  
  try {
    showLoading()
    
    const formData = new FormData(event.target)
    
    const response = await fetch("api/profile/update.php", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      showToast("Perfil actualizado exitosamente", "success")
      
      // Actualizar datos del usuario en localStorage
      const userData = JSON.parse(localStorage.getItem("userData"))
      userData.nombre = formData.get("nombre")
      userData.email = formData.get("email")
      userData.telefono = formData.get("telefono")
      localStorage.setItem("userData", JSON.stringify(userData))
      
      // Actualizar UI
      document.getElementById("userName").textContent = userData.nombre
      document.getElementById("userEmail").textContent = userData.email
      
      // Actualizar en el header si existe
      const headerUserName = document.querySelector(".auth-buttons .font-medium")
      if (headerUserName) {
        headerUserName.textContent = `Hola, ${userData.nombre}`
      }
      
      // Recargar perfil
      loadUserProfile()
    } else {
      showToast(result.message || "Error al actualizar perfil", "error")
    }
  } catch (error) {
    console.error("Update profile error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Actualizar preferencias
async function updatePreferences(event) {
  event.preventDefault()
  
  try {
    showLoading()
    
    const formData = new FormData(event.target)
    
    // Añadir preferencias personalizadas actuales al formData
    userPreferences.forEach((pref, index) => {
      formData.append(`preferences[${index}]`, pref.preferencia)
    })
    
    const response = await fetch("api/client/update-preferences.php", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      showToast("Preferencias actualizadas exitosamente", "success")
      
      // Recargar preferencias para reflejar los cambios
      await loadUserPreferences()
    } else {
      showToast(result.message || "Error al actualizar preferencias", "error")
    }
  } catch (error) {
    console.error("Update preferences error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Añadir a favoritos
async function addToFavorites(type, id) {
  try {
    showLoading()
    
    const response = await fetch(`api/client/add-favorite.php`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({ type, id }),
    })

    const result = await response.json()

    if (result.success) {
      showToast("Añadido a favoritos exitosamente", "success")
      
      // Recargar lista de favoritos
      if (type === "chef") {
        loadFavoriteChefs()
      } else if (type === "recipe") {
        loadFavoriteRecipes()
      }
    } else {
      showToast(result.message || "Error al añadir a favoritos", "error")
    }
  } catch (error) {
    console.error("Add to favorites error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Eliminar de favoritos
async function removeFromFavorites(type, id) {
  try {
    showLoading()
    
    const response = await fetch(`api/client/remove-favorite.php`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({ type, id }),
    })

    const result = await response.json()

    if (result.success) {
      showToast("Eliminado de favoritos exitosamente", "success")
      
      // Actualizar lista de favoritos
      if (type === "chef") {
        favoriteChefs = favoriteChefs.filter(chef => chef.id !== id)
        displayFavoriteChefs()
      } else if (type === "recipe") {
        favoriteRecipes = favoriteRecipes.filter(recipe => recipe.id !== id)
        displayFavoriteRecipes()
      }
    } else {
      showToast(result.message || "Error al eliminar de favoritos", "error")
    }
  } catch (error) {
    console.error("Remove from favorites error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Ver perfil de chef
function viewChefProfile(chefId) {
  window.location.href = `chef-profile.html?id=${chefId}`
}

// Ver receta
function viewRecipe(recipeId) {
  window.location.href = `recipe-details.html?id=${recipeId}`
}

// Editar reseña
async function editReview(reviewId) {
  const review = userReviews.find(r => r.id === reviewId)
  if (!review) return
  
  const confirmed = await showConfirmationModal({
    type: 'accept',
    title: '¿Editar Reseña?',
    message: '¿Deseas editar esta reseña? Se abrirá un formulario para modificar tu calificación y comentarios.',
    confirmText: 'Sí, Editar',
    cancelText: 'Cancelar'
  })
  
  if (confirmed) {
    // Aquí se implementaría la lógica para editar la reseña
    // Por ejemplo, mostrar un modal con un formulario
    alert('Funcionalidad de edición de reseñas en desarrollo')
  }
}

// Eliminar reseña
async function deleteReview(reviewId) {
  const confirmed = await showConfirmationModal({
    type: 'reject',
    title: '¿Eliminar Reseña?',
    message: '¿Estás seguro de que quieres eliminar esta reseña? Esta acción no se puede deshacer.',
    confirmText: 'Sí, Eliminar',
    cancelText: 'Cancelar'
  })
  
  if (!confirmed) return
  
  try {
    showLoading()
    
    const response = await fetch(`api/client/reviews.php`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({ id: reviewId }),
    })

    const result = await response.json()

    if (result.success) {
      showToast("Reseña eliminada exitosamente", "success")
      
      // Actualizar lista de reseñas
      userReviews = userReviews.filter(review => review.id !== reviewId)
      displayUserReviews()
    } else {
      showToast(result.message || "Error al eliminar reseña", "error")
    }
  } catch (error) {
    console.error("Delete review error:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Cambiar entre tabs
function showUserTab(tabId) {
  // Ocultar todos los tabs
  document.querySelectorAll(".user-tab-content").forEach(tab => {
    tab.classList.remove("active")
  })
  
  // Mostrar el tab seleccionado
  document.getElementById(`tab-${tabId}`).classList.add("active")
  
  // Actualizar estado activo en navegación
  document.querySelectorAll(".user-tab-btn").forEach(item => {
    item.classList.remove("active")
  })
  
  document.querySelector(`.user-tab-btn[data-tab="${tabId}"]`).classList.add("active")
  
  // Cargar datos específicos de la pestaña
  if (tabId === 'chat') {
    loadProfileConversations()
  } else if (tabId === 'services') {
    loadCompletedServices()
  }
}

// Mantener compatibilidad con la función anterior
function showTab(tabId) {
  showUserTab(tabId)
}

// Generar estrellas para calificación
function generateStars(rating) {
  if (!rating) return "☆☆☆☆☆"
  
  const fullStars = Math.floor(rating)
  const halfStar = rating % 1 >= 0.5
  const emptyStars = 5 - fullStars - (halfStar ? 1 : 0)
  
  return "★".repeat(fullStars) + (halfStar ? "½" : "") + "☆".repeat(emptyStars)
}

// Variables globales para reseñas
let completedServices = []
let currentReviewServiceId = null
let selectedRating = 0

// Abrir modal de reseña
function openReviewModal(serviceId, chefName) {
  console.log('openReviewModal called with:', serviceId, chefName)
  
  try {
    currentReviewServiceId = serviceId
    
    const reviewServiceIdElement = document.getElementById('reviewServiceId')
    const reviewModalElement = document.getElementById('reviewModal')
    
    console.log('reviewServiceIdElement:', reviewServiceIdElement)
    console.log('reviewModalElement:', reviewModalElement)
    
    if (!reviewServiceIdElement) {
      console.error('reviewServiceId element not found')
      alert('Error: No se encontró el elemento reviewServiceId')
      return
    }
    
    if (!reviewModalElement) {
      console.error('reviewModal element not found')
      alert('Error: No se encontró el modal de reseñas')
      return
    }
    
    reviewServiceIdElement.value = serviceId
    reviewModalElement.style.display = 'flex'
    
    console.log('Modal display set to flex')
    
    // Resetear formulario
    const reviewForm = document.getElementById('reviewForm')
    if (reviewForm) {
      reviewForm.reset()
      console.log('Form reset')
    }
    
    selectedRating = 0
    updateStarsDisplay(0)
    
    // Inicializar sistema de estrellas
    initializeStarRating()
    
    // Actualizar título del modal
    const modalTitle = document.querySelector('#reviewModal .modal-header h3')
    if (modalTitle) {
      modalTitle.textContent = `Calificar a Chef ${chefName}`
      console.log('Modal title updated')
    }
    
    console.log('Modal should be visible now')
    
  } catch (error) {
    console.error('Error in openReviewModal:', error)
    alert('Error al abrir el modal: ' + error.message)
  }
}

// Hacer la función global
window.openReviewModal = openReviewModal

// Cerrar modal de reseña
function closeReviewModal() {
  document.getElementById('reviewModal').style.display = 'none'
  currentReviewServiceId = null
  selectedRating = 0
}

// Hacer la función global
window.closeReviewModal = closeReviewModal

// Manejar calificación con estrellas
function initializeStarRating() {
  const starInputs = document.querySelectorAll('.star-input')
  
  starInputs.forEach((star, index) => {
    star.addEventListener('click', () => {
      selectedRating = index + 1
      document.getElementById('reviewRating').value = selectedRating
      updateStarsDisplay(selectedRating)
    })
    
    star.addEventListener('mouseenter', () => {
      updateStarsDisplay(index + 1, true)
    })
  })
  
  document.getElementById('starsInput').addEventListener('mouseleave', () => {
    updateStarsDisplay(selectedRating)
  })
}

// Actualizar visualización de estrellas
function updateStarsDisplay(rating, isHover = false) {
  const starInputs = document.querySelectorAll('.star-input')
  
  starInputs.forEach((star, index) => {
    if (index < rating) {
      star.textContent = '★'
      star.classList.add('active')
    } else {
      star.textContent = '☆'
      star.classList.remove('active')
    }
  })
}

// Enviar reseña
async function submitReview(event) {
  event.preventDefault()
  
  if (selectedRating === 0) {
    showToast('Por favor selecciona una calificación', 'error')
    return
  }
  
  const formData = new FormData(event.target)
  const reviewData = {
    servicio_id: parseInt(formData.get('servicio_id')),
    puntuacion: selectedRating,
    comentario: formData.get('comentario'),
    titulo: formData.get('titulo') || null,
    aspectos_positivos: formData.get('aspectos_positivos') || null,
    aspectos_mejora: formData.get('aspectos_mejora') || null,
    recomendaria: formData.get('recomendaria') ? 1 : 0
  }
  
  try {
    showLoading()
    
    const response = await fetch('api/client/reviews.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      },
      body: JSON.stringify(reviewData)
    })
    
    const result = await response.json()
    
    if (result.success) {
      showToast('Reseña enviada exitosamente', 'success')
      closeReviewModal()
      
      // Recargar servicios y reseñas
      await loadCompletedServices()
      await loadUserReviews()
    } else {
      showToast(result.message || 'Error al enviar reseña', 'error')
    }
  } catch (error) {
    console.error('Submit review error:', error)
    showToast('Error de conexión', 'error')
  } finally {
    hideLoading()
  }
}

// Hacer la función global
window.submitReview = submitReview

// Formatear fecha
function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString("es-ES", {
    year: "numeric",
    month: "long",
    day: "numeric"
  })
}

// Mostrar indicador de carga
function showLoading() {
  const loadingIndicator = document.createElement("div")
  loadingIndicator.className = "loading-indicator"
  loadingIndicator.innerHTML = `
    <div class="spinner"></div>
    <p>Cargando...</p>
  `
  document.body.appendChild(loadingIndicator)
}

// Ocultar indicador de carga
function hideLoading() {
  const loadingIndicator = document.querySelector(".loading-indicator")
  if (loadingIndicator) {
    loadingIndicator.remove()
  }
}

// Mostrar toast de notificación
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
      toast.remove()
    }, 300)
  }, 3000)
}

// Funciones para el chat en el perfil
async function loadProfileConversations() {
  try {
    const response = await fetch('api/messages/conversations.php', {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      }
    })
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const result = await response.json()
    
    if (result.success) {
      profileConversations = result.data
      displayProfileConversations()
    } else {
      console.error('Error loading conversations:', result.message)
      showToast(result.message || 'Error al cargar conversaciones', 'error')
      // Mostrar mensaje en la interfaz
      const conversationsContainer = document.getElementById('profileConversationsList')
      if (conversationsContainer) {
        conversationsContainer.innerHTML = '<p class="text-center text-red-500 p-3">Error al cargar conversaciones. Por favor, intenta de nuevo.</p>'
      }
    }
  } catch (error) {
    console.error('Error loading conversations:', error)
    showToast('Error de conexión al cargar conversaciones', 'error')
    // Mostrar mensaje en la interfaz
    const conversationsContainer = document.getElementById('profileConversationsList')
    if (conversationsContainer) {
      conversationsContainer.innerHTML = '<p class="text-center text-red-500 p-3">Error de conexión. Verifica tu conexión a internet.</p>'
    }
  }
}

function displayProfileConversations() {
  const conversationsContainer = document.getElementById('profileConversationsList')
  if (!conversationsContainer) return
  
  if (profileConversations.length === 0) {
    conversationsContainer.innerHTML = '<p class="text-center text-gray-500">No tienes conversaciones activas</p>'
    return
  }
  
  conversationsContainer.innerHTML = profileConversations.map(conversation => `
    <div class="conversation-item ${
      currentProfileConversation === conversation.servicio_id ? 'active' : ''
    }" onclick="selectProfileConversation(${conversation.servicio_id})">
      <div class="flex items-center">
        <div class="conversation-avatar mr-3">
          <span>${conversation.chef_nombre.charAt(0).toUpperCase()}</span>
          <div class="online-indicator"></div>
        </div>
        <div class="flex-1 min-w-0">
          <div class="flex justify-between items-start">
            <h5 class="font-semibold text-sm text-gray-800 truncate">${conversation.chef_nombre}</h5>
            ${conversation.mensajes_no_leidos > 0 ? 
              `<span class="unread-badge">${conversation.mensajes_no_leidos}</span>` : 
              ''
            }
          </div>
          <p class="text-xs text-gray-600 truncate mt-1">${conversation.ultimo_mensaje || 'Sin mensajes'}</p>
          <p class="text-xs text-gray-500 mt-1">${formatDate(conversation.fecha_actualizacion)}</p>
        </div>
      </div>
    </div>
  `).join('')
}

function selectProfileConversation(servicioId) {
  currentProfileConversation = servicioId
  displayProfileConversations()
  loadProfileMessages(servicioId)
}

async function loadProfileMessages(servicioId) {
  try {
    const response = await fetch(`api/messages/list.php?servicio_id=${servicioId}`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      }
    })
    
    const result = await response.json()
    
    if (result.success) {
      displayProfileMessages(result.data)
    } else {
      console.error('Error loading messages:', result.message)
      showToast(result.message || 'Error al cargar mensajes', 'error')
    }
  } catch (error) {
    console.error('Error loading messages:', error)
    showToast('Error de conexión al cargar mensajes', 'error')
  }
}

function displayProfileMessages(messages) {
  const messagesContainer = document.getElementById('profileMessagesContainer')
  if (!messagesContainer) return
  
  if (messages.length === 0) {
    messagesContainer.innerHTML = `
      <div class="text-center py-12">
        <div class="conversation-avatar mx-auto mb-4">
          <span>💬</span>
        </div>
        <p class="text-gray-500">No hay mensajes en esta conversación.</p>
        <p class="text-sm text-gray-400 mt-2">¡Sé el primero en enviar un mensaje!</p>
      </div>
    `
    return
  }
  
  messagesContainer.innerHTML = messages.map(message => `
    <div class="message ${message.remitente_id === currentUser.id ? 'sent' : 'received'}">
      <div class="message-bubble">
        <p class="text-sm">${message.mensaje}</p>
        <span class="message-time">${formatDate(message.fecha_envio)}</span>
      </div>
    </div>
  `).join('')
  
  messagesContainer.scrollTop = messagesContainer.scrollHeight
}

function addMessageToDisplay(messageData) {
  const messagesContainer = document.getElementById('profileMessagesContainer')
  if (!messagesContainer) return
  
  const messageHtml = `
    <div class="message sent">
      <div class="message-bubble">
        <p class="text-sm">${messageData.mensaje}</p>
        <span class="message-time">${formatDate(messageData.fecha_envio)}</span>
      </div>
    </div>
  `
  
  messagesContainer.insertAdjacentHTML('beforeend', messageHtml)
  messagesContainer.scrollTop = messagesContainer.scrollHeight
}

async function sendProfileMessage() {
  const messageInput = document.getElementById('profileMessageInput')
  const message = messageInput.value.trim()
  
  if (!message || !currentProfileConversation) {
    if (!message) {
      showToast('Por favor escribe un mensaje', 'warning')
    }
    return
  }
  
  // Deshabilitar el input mientras se envía
  messageInput.disabled = true
  const sendButton = document.querySelector('#profileChatArea button')
  if (sendButton) sendButton.disabled = true
  
  try {
    const response = await fetch('api/messages/send.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      },
      body: JSON.stringify({
        servicio_id: currentProfileConversation,
        mensaje: message
      })
    })
    
    const result = await response.json()
    
    if (result.success) {
      messageInput.value = ''
      // Recargar mensajes para mostrar el nuevo mensaje
      await loadProfileMessages(currentProfileConversation)
      // Recargar conversaciones para actualizar el último mensaje
      await loadProfileConversations()
      showToast('Mensaje enviado', 'success')
    } else {
      showToast(result.message || 'Error al enviar mensaje', 'error')
    }
  } catch (error) {
    console.error('Error sending message:', error)
    showToast('Error de conexión', 'error')
  } finally {
    // Rehabilitar el input
    messageInput.disabled = false
    if (sendButton) sendButton.disabled = false
    messageInput.focus()
  }
}

// Custom Modal Functions (copiadas de dashboard.js para mantener consistencia)
function showConfirmationModal(options) {
  return new Promise((resolve) => {
    const modal = document.createElement('div')
    modal.className = 'confirmation-modal'
    
    const iconClass = options.type || 'accept'
    const iconSymbol = {
      'accept': '✓',
      'reject': '✕',
      'cancel': '⚠'
    }[iconClass] || '?'
    
    modal.innerHTML = `
      <div class="confirmation-modal-content">
        <div class="confirmation-modal-icon ${iconClass}">
          ${iconSymbol}
        </div>
        <h3 class="confirmation-modal-title">${options.title}</h3>
        <p class="confirmation-modal-message">${options.message}</p>
        <div class="confirmation-modal-actions">
          <button class="confirmation-modal-btn secondary" onclick="closeConfirmationModal(false)">
            ${options.cancelText || 'Cancelar'}
          </button>
          <button class="confirmation-modal-btn primary" onclick="closeConfirmationModal(true)">
            ${options.confirmText || 'Confirmar'}
          </button>
        </div>
      </div>
    `
    
    document.body.appendChild(modal)
    
    // Add close function to window for onclick handlers
    window.closeConfirmationModal = (result) => {
      modal.classList.remove('show')
      setTimeout(() => {
        document.body.removeChild(modal)
        delete window.closeConfirmationModal
        resolve(result)
      }, 300)
    }
    
    // Show modal with animation
    setTimeout(() => modal.classList.add('show'), 10)
    
    // Close on backdrop click
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        window.closeConfirmationModal(false)
      }
    })
  })
}