// Dashboard JavaScript for La Délicatesse

// Global variables
// currentUser is declared globally in main.js
let currentSection = "overview"
let services = []
let userRecipes = []
let conversations = []
let currentConversation = null

// Initialize dashboard
document.addEventListener("DOMContentLoaded", async () => {
  await checkAuthStatus()
  loadDashboardData()
  setupDashboardEventListeners()
  loadProfileData()
})

// Check authentication status
async function checkAuthStatus() {
  const token = localStorage.getItem("authToken")
  const userData = localStorage.getItem("userData")

  if (!token || !userData) {
    window.location.href = "index.html"
    return
  }

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

  // Only allow chefs to access dashboard
  if (currentUser.tipo_usuario !== "chef") {
    window.location.href = "index.html"
    return
  }

  document.getElementById("userName").textContent = currentUser.nombre

  // Set user initials for avatar
  const initials = currentUser.nombre
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase()
  document.getElementById("userInitials").textContent = initials
}

// Setup event listeners
function setupDashboardEventListeners() {
  // Message input enter key
  const messageInput = document.getElementById("messageInput")
  if (messageInput) {
    messageInput.addEventListener("keypress", (e) => {
      if (e.key === "Enter") {
        sendMessage()
      }
    })
  }
}

// Load profile data
async function loadProfileData() {
  try {
    const response = await fetch("api/profile/get.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      const profile = result.data

      // Fill profile form
      document.getElementById("profileNombre").value = profile.nombre || ""
      document.getElementById("profileEmail").value = profile.email || ""
      document.getElementById("profileTelefono").value = profile.telefono || ""
      document.getElementById("profileEspecialidad").value = profile.especialidad || ""
      document.getElementById("profileExperiencia").value = profile.experiencia_anos || ""
      document.getElementById("profileUbicacion").value = profile.ubicacion || ""
      document.getElementById("profilePrecio").value = profile.precio_por_hora || ""
      document.getElementById("profileBiografia").value = profile.biografia || ""
      document.getElementById("profileCertificaciones").value = profile.certificaciones || ""

      // Load profile photo if exists
      if (profile.foto_perfil) {
        const profileImg = document.getElementById("profilePhotoPreview")
        const placeholder = document.getElementById("profilePhotoPlaceholder")
        const userAvatarImg = document.getElementById("userAvatarImg")
        const userAvatarPlaceholder = document.getElementById("userAvatarPlaceholder")

        profileImg.src = profile.foto_perfil
        profileImg.classList.remove("hidden")
        placeholder.classList.add("hidden")

        userAvatarImg.src = profile.foto_perfil
        userAvatarImg.classList.remove("hidden")
        userAvatarPlaceholder.classList.add("hidden")
      }
    }
  } catch (error) {
    console.error("Error loading profile:", error)
  }
}

// Preview profile photo
function previewProfilePhoto(event) {
  const file = event.target.files[0]
  if (file) {
    // Validate file size (2MB max)
    if (file.size > 2 * 1024 * 1024) {
      showToast("La imagen debe ser menor a 2MB", "error")
      return
    }

    // Validate file type
    if (!file.type.startsWith("image/")) {
      showToast("Solo se permiten archivos de imagen", "error")
      return
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      const profileImg = document.getElementById("profilePhotoPreview")
      const placeholder = document.getElementById("profilePhotoPlaceholder")

      profileImg.src = e.target.result
      profileImg.classList.remove("hidden")
      placeholder.classList.add("hidden")
    }
    reader.readAsDataURL(file)
  }
}

// Reset profile form
function resetProfileForm() {
  document.getElementById("profileForm").reset()
  loadProfileData()

  const profileImg = document.getElementById("profilePhotoPreview")
  const placeholder = document.getElementById("profilePhotoPlaceholder")

  profileImg.classList.add("hidden")
  placeholder.classList.remove("hidden")
}

// Load dashboard data
async function loadDashboardData() {
  await Promise.all([loadUserStats(), loadServices(), loadUserRecipes(), loadConversations(), loadRecentActivity(), loadNotifications()])
}

// Load user statistics
async function loadUserStats() {
  try {
    const response = await fetch("api/dashboard/stats.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      const stats = result.data
      document.getElementById("totalServices").textContent = stats.total_services || 0
      document.getElementById("avgRating").textContent = (stats.avg_rating || 0).toFixed(1)
      document.getElementById("totalEarnings").textContent = formatCurrency(stats.total_earnings || 0)
    }
  } catch (error) {
    console.error("Error loading stats:", error)
  }
}

// Load services
async function loadServices() {
  try {
    const response = await fetch("api/services/chef-services.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      services = result.data
      displayServices()
      displayServicesCalendar()
    }
  } catch (error) {
    console.error("Error loading services:", error)
  }
}

// Display services
function displayServices() {
  const servicesList = document.getElementById("servicesList")
  if (!servicesList) return

  if (services.length === 0) {
    servicesList.innerHTML =
      '<p class="text-center" style="color: var(--text-light);">No tienes servicios registrados.</p>'
    return
  }

  servicesList.innerHTML = services
    .map(
      (service) => `
        <div class="p-6 card-hover" style="background-color: var(--light-bg); border: 1px solid var(--border-color); border-radius: var(--border-radius-lg);">
            <div class="flex justify-between items-start mb-4">
                <div>
                    <h4 class="text-lg font-semibold mb-2" style="color: var(--primary-color); font-family: var(--font-heading);">${service.cliente_nombre}</h4>
                    <p style="color: var(--text-light);">${formatDate(service.fecha_servicio)} - ${service.hora_servicio}</p>
                    <p style="color: var(--text-light);">${service.ubicacion_servicio}</p>
                    <p style="color: var(--text-light);">Comensales: ${service.numero_comensales}</p>
                </div>
                <div class="text-right">
                    <span class="status-badge status-${service.estado}">${getStatusText(service.estado)}</span>
                    <p class="text-lg font-bold mt-2" style="color: var(--accent-color); font-family: var(--font-heading);">${formatCurrency(service.precio_total)}</p>
                </div>
            </div>
            
            <div class="flex gap-2">
                <button onclick="viewServiceDetails(${service.id})" class="btn btn-outline btn-sm">
                    Ver Detalles
                </button>
                ${
                  service.estado === "pendiente"
                    ? `
                    <button onclick="acceptService(${service.id})" class="btn btn-primary btn-sm">
                        Aceptar
                    </button>
                    <button onclick="rejectService(${service.id})" class="btn btn-outline btn-sm" style="color: #dc2626; border-color: #dc2626;">
                        Rechazar
                    </button>
                `
                    : service.estado === "aceptado"
                    ? `
                    <button onclick="completeService(${service.id})" class="btn btn-primary btn-sm">
                        Marcar Completado
                    </button>
                    <button onclick="cancelService(${service.id})" class="btn btn-outline btn-sm" style="color: #dc2626; border-color: #dc2626;">
                        Cancelar
                    </button>
                `
                    : ""
                }
            </div>
        </div>
    `,
    )
    .join("")
}

// Load user recipes
async function loadUserRecipes() {
  try {
    const response = await fetch("api/recipes/user-recipes.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      userRecipes = result.data
      displayUserRecipes()
    }
  } catch (error) {
    console.error("Error loading recipes:", error)
  }
}

// Display user recipes
function displayUserRecipes() {
  const recipesList = document.getElementById("recipesList")
  if (!recipesList) return

  if (userRecipes.length === 0) {
    recipesList.innerHTML =
      '<p class="text-center col-span-full" style="color: var(--text-light);">No tienes recetas publicadas.</p>'
    return
  }

  recipesList.innerHTML = userRecipes
    .map(
      (recipe) => `
        <div class="recipe-card">
            <div class="recipe-image">
                <img src="${recipe.imagen || "/placeholder.svg?height=150&width=200"}" 
                     alt="${recipe.titulo}">
                <div class="recipe-badge">${recipe.dificultad}</div>
            </div>
            <div class="recipe-info">
                <h4 class="font-semibold mb-2" style="color: var(--primary-color); font-family: var(--font-heading);">${recipe.titulo}</h4>
                <p class="text-sm mb-2 line-clamp-2" style="color: var(--text-light);">${recipe.descripcion || ""}</p>
                <div class="flex justify-between items-center mb-3">
                    <span class="font-bold" style="color: var(--accent-color);">${formatCurrency(recipe.precio)}</span>
                    <span class="text-sm" style="color: var(--text-light);">${recipe.ventas || 0} ventas</span>
                </div>
                <div class="flex gap-2">
                    <button onclick="editRecipe(${recipe.id})" class="btn btn-outline btn-sm flex-1">
                        Editar
                    </button>
                    <button onclick="deleteRecipe(${recipe.id})" class="btn btn-outline btn-sm flex-1" style="color: #dc2626; border-color: #dc2626;">
                        Eliminar
                    </button>
                </div>
            </div>
        </div>
    `,
    )
    .join("")
}

// Load conversations
async function loadConversations() {
  try {
    const response = await fetch("api/messages/conversations.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const text = await response.text()
    
    // Verificar si la respuesta es JSON válido
    let result
    try {
      result = JSON.parse(text)
    } catch (parseError) {
      console.error('Error parsing JSON response:', parseError)
      console.error('Response text:', text)
      throw new Error('El servidor devolvió una respuesta inválida')
    }

    if (result.success) {
      conversations = result.data
      displayConversations()
    } else {
      console.error('Error loading conversations:', result.message)
      showToast(result.message || 'Error al cargar conversaciones', 'error')
      // Mostrar mensaje en la interfaz
      const conversationsList = document.getElementById("conversationsList")
      if (conversationsList) {
        conversationsList.innerHTML = '<p class="text-sm text-red-500 p-3">Error al cargar conversaciones. Por favor, intenta de nuevo.</p>'
      }
    }
  } catch (error) {
    console.error("Error loading conversations:", error)
    showToast('Error de conexión al cargar conversaciones', 'error')
    // Mostrar mensaje en la interfaz
    const conversationsList = document.getElementById("conversationsList")
    if (conversationsList) {
      conversationsList.innerHTML = '<p class="text-sm text-red-500 p-3">Error de conexión. Verifica tu conexión a internet.</p>'
    }
  }
}

// Display conversations
function displayConversations() {
  const conversationsList = document.getElementById("conversationsList")
  if (!conversationsList) return

  if (conversations.length === 0) {
    conversationsList.innerHTML = '<p class="text-sm" style="color: var(--text-light);">No hay conversaciones.</p>'
    return
  }

  conversationsList.innerHTML = conversations
    .map(
      (conv) => `
        <div onclick="selectConversation(${conv.servicio_id})" 
             class="conversation-item ${currentConversation === conv.servicio_id ? "active" : ""}">
            <div class="flex items-center">
                <div class="conversation-avatar mr-3">
                    <span>${conv.otro_usuario.charAt(0).toUpperCase()}</span>
                    <div class="online-indicator"></div>
                </div>
                <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-start">
                        <h5 class="font-semibold text-sm text-gray-800 truncate">${conv.otro_usuario}</h5>
                        ${conv.mensajes_no_leidos > 0 ? `<span class="unread-badge">${conv.mensajes_no_leidos}</span>` : ''}
                    </div>
                    <p class="text-xs text-gray-600 truncate mt-1">${conv.ultimo_mensaje || 'Sin mensajes'}</p>
                    <p class="text-xs text-gray-500 mt-1">${formatDate(conv.fecha_ultimo)}</p>
                </div>
            </div>
        </div>
    `,
    )
    .join("")
}

// Load recent activity
async function loadRecentActivity() {
  try {
    const response = await fetch("api/dashboard/recent-activity.php", {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      displayRecentActivity(result.data)
    }
  } catch (error) {
    console.error("Error loading recent activity:", error)
  }
}

// Display recent activity
function displayRecentActivity(activities) {
  const recentActivity = document.getElementById("recentActivity")
  if (!recentActivity) return

  if (activities.length === 0) {
    recentActivity.innerHTML = '<p style="color: var(--text-light);">No hay actividad reciente.</p>'
    return
  }

  recentActivity.innerHTML = activities
    .map(
      (activity) => `
        <div class="flex items-center space-x-3 p-4 rounded-lg" style="background-color: var(--gray-bg);">
            <div class="w-10 h-10 rounded-full flex items-center justify-center" style="background-color: rgba(139, 90, 43, 0.1);">
                <span style="color: var(--primary-color);">${activity.icon || '📋'}</span>
            </div>
            <div class="flex-1">
                <p class="text-sm" style="color: var(--text-color);">${activity.descripcion}</p>
                <p class="text-xs" style="color: var(--text-light);">${formatDate(activity.fecha)}</p>
            </div>
        </div>
    `,
    )
    .join("")
}

// Navigation functions
function showSection(sectionId) {
  // Hide all sections
  document.querySelectorAll(".dashboard-section").forEach((section) => {
    section.classList.add("hidden")
  })

  // Show selected section
  document.getElementById(sectionId).classList.remove("hidden")

  // Update navigation
  document.querySelectorAll(".dashboard-nav-btn").forEach((btn) => {
    btn.classList.remove("active")
  })
  event.target.classList.add("active")

  currentSection = sectionId

  // Cargar datos específicos de la sección
  if (sectionId === 'messages') {
    loadConversations()
  }
}

// Service functions
function viewServiceDetails(serviceId) {
  const service = services.find((s) => s.id === serviceId)
  if (!service) return

  const serviceDetails = document.getElementById("serviceDetails")
  serviceDetails.innerHTML = `
        <div class="space-y-6">
            <div>
                <h4 class="font-semibold text-lg mb-4" style="color: var(--primary-color); font-family: var(--font-heading);">Detalles del Servicio</h4>
                <div class="grid md:grid-cols-2 gap-4">
                    <div class="form-group">
                        <label>Cliente</label>
                        <p class="font-medium" style="color: var(--text-color);">${service.cliente_nombre}</p>
                    </div>
                    <div class="form-group">
                        <label>Fecha</label>
                        <p class="font-medium" style="color: var(--text-color);">${formatDate(service.fecha_servicio)}</p>
                    </div>
                    <div class="form-group">
                        <label>Hora</label>
                        <p class="font-medium" style="color: var(--text-color);">${service.hora_servicio}</p>
                    </div>
                    <div class="form-group">
                        <label>Comensales</label>
                        <p class="font-medium" style="color: var(--text-color);">${service.numero_comensales}</p>
                    </div>
                    <div class="form-group">
                        <label>Precio</label>
                        <p class="font-medium" style="color: var(--accent-color);">${formatCurrency(service.precio_total)}</p>
                    </div>
                    <div class="form-group">
                        <label>Estado</label>
                        <span class="status-badge status-${service.estado}">${service.estado}</span>
                    </div>
                </div>
                <div class="form-group">
                    <label>Ubicación</label>
                    <p class="font-medium" style="color: var(--text-color);">${service.ubicacion_servicio}</p>
                </div>
            </div>
            
            ${
              service.descripcion_evento
                ? `
                <div class="form-group">
                    <label>Descripción del Evento</label>
                    <p class="p-3 rounded-lg" style="color: var(--text-light); background-color: var(--gray-bg);">${service.descripcion_evento}</p>
                </div>
            `
                : ""
            }
            
            <div class="flex gap-4 pt-4">
                <button onclick="closeModal('serviceModal')" class="btn btn-outline">
                    Cerrar
                </button>
                ${
                  service.estado === "aceptado"
                    ? `
                    <button onclick="openChat(${service.id})" class="btn btn-primary">
                        Abrir Chat
                    </button>
                `
                    : ""
                }
            </div>
        </div>
    `

  openModal("serviceModal")
}

async function acceptService(serviceId) {
  try {
    const response = await fetch("api/services/accept.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({ service_id: serviceId }),
    })

    const result = await response.json()

    if (result.success) {
      showToast("Servicio aceptado exitosamente", "success")
      loadServices()
    } else {
      showToast(result.message || "Error al aceptar servicio", "error")
    }
  } catch (error) {
    console.error("Error accepting service:", error)
    showToast("Error de conexión", "error")
  }
}

async function rejectService(serviceId) {
  try {
    const response = await fetch("api/services/reject.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({ service_id: serviceId }),
    })

    const result = await response.json()

    if (result.success) {
      showToast("Servicio rechazado", "info")
      loadServices()
    } else {
      showToast(result.message || "Error al rechazar servicio", "error")
    }
  } catch (error) {
    console.error("Error rejecting service:", error)
    showToast("Error de conexión", "error")
  }
}

// Recipe functions
function editRecipe(recipeId) {
  // Por ahora mostrar un toast indicando que la funcionalidad está en desarrollo
  showToast("Funcionalidad de edición en desarrollo", "info")
  console.log("Edit recipe:", recipeId)
}

async function deleteRecipe(recipeId) {
  const confirmed = await showConfirmationModal({
    type: 'reject',
    title: '¿Eliminar Receta?',
    message: '¿Estás seguro de que quieres eliminar esta receta? Esta acción no se puede deshacer.',
    confirmText: 'Sí, Eliminar',
    cancelText: 'Cancelar'
  })
  
  if (!confirmed) {
    return
  }

  try {
    showLoading()
    const response = await fetch("api/recipes/delete.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({ recipe_id: recipeId }),
    })

    const result = await response.json()

    if (result.success) {
      showToast("Receta eliminada exitosamente", "success")
      loadUserRecipes()
    } else {
      showToast(result.message || "Error al eliminar receta", "error")
    }
  } catch (error) {
    console.error("Error deleting recipe:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Message functions
function selectConversation(servicioId) {
  currentConversation = servicioId
  displayConversations()
  loadMessages(servicioId)
}

async function loadMessages(servicioId) {
  try {
    const response = await fetch(`api/messages/list.php?servicio_id=${servicioId}`, {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
    })

    const result = await response.json()

    if (result.success) {
      displayMessages(result.data)
    } else {
      console.error('Error loading messages:', result.message)
      showToast(result.message || 'Error al cargar mensajes', 'error')
    }
  } catch (error) {
    console.error("Error loading messages:", error)
    showToast('Error de conexión al cargar mensajes', 'error')
  }
}

function displayMessages(messages) {
  const messagesContainer = document.getElementById("messagesContainer")
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

  messagesContainer.innerHTML = messages
    .map(
      (message) => `
        <div class="message ${message.remitente_id === currentUser.id ? "sent" : "received"}">
            <div class="message-bubble">
                <p class="text-sm">${message.mensaje}</p>
                <span class="message-time">${formatDate(message.fecha_envio)}</span>
            </div>
        </div>
    `,
    )
    .join("")

  messagesContainer.scrollTop = messagesContainer.scrollHeight
}

async function sendMessage() {
  const messageInput = document.getElementById("messageInput")
  const message = messageInput.value.trim()

  if (!message || !currentConversation) {
    if (!message) {
      showToast('Por favor escribe un mensaje', 'warning')
    }
    return
  }

  // Deshabilitar el input mientras se envía
  messageInput.disabled = true
  const sendButton = document.querySelector('#chatArea button')
  if (sendButton) sendButton.disabled = true

  try {
    const response = await fetch("api/messages/send.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: JSON.stringify({
        servicio_id: currentConversation,
        mensaje: message,
      }),
    })

    const result = await response.json()

    if (result.success) {
      messageInput.value = ""
      // Recargar mensajes y conversaciones para actualizar
      await loadMessages(currentConversation)
      await loadConversations()
      showToast('Mensaje enviado', 'success')
    } else {
      showToast(result.message || "Error al enviar mensaje", "error")
    }
  } catch (error) {
    console.error("Error sending message:", error)
    showToast("Error de conexión", "error")
  } finally {
    // Rehabilitar el input
    messageInput.disabled = false
    if (sendButton) sendButton.disabled = false
    messageInput.focus()
  }
}

// Función para abrir el chat desde el modal de detalles del servicio
function openChat(servicioId) {
  // Cerrar el modal de detalles del servicio
  closeModal('serviceModal')
  
  // Cambiar a la sección de mensajes
  showSection('messages')
  
  // Cargar las conversaciones si no están cargadas
  if (conversations.length === 0) {
    loadConversations().then(() => {
      // Seleccionar la conversación específica
      selectConversation(servicioId)
    })
  } else {
    // Seleccionar la conversación específica
    selectConversation(servicioId)
  }
  
  showToast('Abriendo chat...', 'info')
}

// Profile functions
async function updateProfile(event) {
  event.preventDefault()
  const formData = new FormData(event.target)

  try {
    showLoading()
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
      currentUser = { ...currentUser, ...result.user }
      localStorage.setItem("userData", JSON.stringify(currentUser))

      // Update header avatar if photo was uploaded
      if (result.user.foto_perfil) {
        const userAvatarImg = document.getElementById("userAvatarImg")
        const userAvatarPlaceholder = document.getElementById("userAvatarPlaceholder")

        userAvatarImg.src = result.user.foto_perfil
        userAvatarImg.classList.remove("hidden")
        userAvatarPlaceholder.classList.add("hidden")
      }
    } else {
      showToast(result.message || "Error al actualizar perfil", "error")
    }
  } catch (error) {
    console.error("Error updating profile:", error)
    showToast("Error de conexión", "error")
  } finally {
    hideLoading()
  }
}

// Recipe form functions
let stepCounter = 1

function addIngredient() {
  const ingredientsList = document.getElementById("ingredientsList")
  const newIngredient = document.createElement("div")
  newIngredient.className = "ingredient-item flex gap-3"
  newIngredient.innerHTML = `
    <input type="text" placeholder="Cantidad" class="w-24" name="ingredient_quantity[]">
    <input type="text" placeholder="Unidad (ej: tazas, gramos)" class="w-32" name="ingredient_unit[]">
    <input type="text" placeholder="Ingrediente" class="flex-1" name="ingredient_name[]">
    <button type="button" onclick="removeIngredient(this)" class="btn btn-outline btn-sm text-red-600 border-red-600">
      Eliminar
    </button>
  `
  ingredientsList.appendChild(newIngredient)
}

function removeIngredient(button) {
  button.parentElement.remove()
}

function addStep() {
  stepCounter++
  const stepsList = document.getElementById("stepsList")
  const newStep = document.createElement("div")
  newStep.className = "step-item p-4 rounded-lg"
  newStep.style.cssText = "border: 1px solid var(--border-color); background-color: var(--gray-bg);"
  newStep.innerHTML = `
    <div class="flex justify-between items-center mb-3">
        <h4 class="font-medium" style="color: var(--primary-color);">Paso ${stepCounter}</h4>
        <button type="button" onclick="removeStep(this)" class="btn btn-outline btn-sm text-red-600 border-red-600">
            Eliminar Paso
        </button>
    </div>
    
    <div class="form-group">
        <label>Descripción del paso</label>
        <textarea name="step_description[]" rows="3" placeholder="Describe detalladamente este paso..." required></textarea>
    </div>
    
    <div class="form-group">
        <label>Foto del paso (opcional)</label>
        <div class="flex items-center gap-4">
            <input type="file" name="step_images[]" accept="image/*" class="hidden" onchange="previewStepImage(this)">
            <button type="button" onclick="this.previousElementSibling.click()" class="btn btn-outline btn-sm">
                Seleccionar Imagen
            </button>
            <div class="step-image-preview hidden">
                <img class="w-20 h-20 object-cover rounded-lg" alt="Preview">
                <button type="button" onclick="removeStepImage(this)" class="text-red-600 text-sm mt-1">Eliminar</button>
            </div>
        </div>
    </div>
  `
  stepsList.appendChild(newStep)
}

function removeStep(button) {
  button.closest('.step-item').remove()
  updateStepNumbers()
}

function updateStepNumbers() {
  const steps = document.querySelectorAll('.step-item h4')
  steps.forEach((step, index) => {
    step.textContent = `Paso ${index + 1}`
  })
  stepCounter = steps.length
}

function previewStepImage(input) {
  const file = input.files[0]
  if (file) {
    if (file.size > 2 * 1024 * 1024) {
      showToast("La imagen debe ser menor a 2MB", "error")
      input.value = ""
      return
    }

    if (!file.type.startsWith("image/")) {
      showToast("Solo se permiten archivos de imagen", "error")
      input.value = ""
      return
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      const preview = input.parentElement.querySelector('.step-image-preview')
      const img = preview.querySelector('img')
      
      img.src = e.target.result
      preview.classList.remove('hidden')
    }
    reader.readAsDataURL(file)
  }
}

function removeStepImage(button) {
  const preview = button.parentElement
  const input = preview.parentElement.querySelector('input[type="file"]')
  
  input.value = ""
  preview.classList.add('hidden')
}

function previewFinalImage(input) {
  const file = input.files[0]
  if (file) {
    if (file.size > 2 * 1024 * 1024) {
      showToast("La imagen debe ser menor a 2MB", "error")
      input.value = ""
      return
    }

    if (!file.type.startsWith("image/")) {
      showToast("Solo se permiten archivos de imagen", "error")
      input.value = ""
      return
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      const preview = document.getElementById('finalImagePreview')
      const img = preview.querySelector('img')
      
      img.src = e.target.result
      preview.classList.remove('hidden')
    }
    reader.readAsDataURL(file)
  }
}

function removeFinalImage() {
  const input = document.querySelector('input[name="final_image"]')
  const preview = document.getElementById('finalImagePreview')
  
  input.value = ""
  preview.classList.add('hidden')
}

// Update the saveRecipe function to handle the new form structure
async function saveRecipe(event) {
  event.preventDefault()
  const formData = new FormData(event.target)

  // Validate that we have at least one ingredient
  const ingredients = formData.getAll('ingredient_name[]').filter(name => name.trim() !== '')
  if (ingredients.length === 0) {
    showToast("Debes agregar al menos un ingrediente", "error")
    return
  }

  // Validate that we have at least one step
  const steps = formData.getAll('step_description[]').filter(desc => desc.trim() !== '')
  if (steps.length === 0) {
    showToast("Debes agregar al menos un paso", "error")
    return
  }

  // Validate final image
  if (!formData.get('final_image') || formData.get('final_image').size === 0) {
    showToast("Debes agregar una imagen del resultado final", "error")
    return
  }

  try {
    showLoading()
    const response = await fetch("api/recipes/save-enhanced.php", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${localStorage.getItem("authToken")}`,
      },
      body: formData,
    })

    const result = await response.json()

    if (result.success) {
      showToast("Receta guardada exitosamente", "success")
      closeModal("recipeModal")
      loadUserRecipes()
      resetRecipeForm()
    } else {
      showToast(result.message || "Error al guardar receta", "error")
    }
  } catch (error) {
    console.error("Error saving recipe:", error)
    showToast("Error de conexión al servidor", "error")
  } finally {
    hideLoading()
  }
}

function resetRecipeForm() {
  document.getElementById("recipeForm").reset()
  
  // Reset ingredients to just one
  const ingredientsList = document.getElementById("ingredientsList")
  ingredientsList.innerHTML = `
    <div class="ingredient-item flex gap-3">
        <input type="text" placeholder="Cantidad" class="w-24" name="ingredient_quantity[]">
        <input type="text" placeholder="Unidad (ej: tazas, gramos)" class="w-32" name="ingredient_unit[]">
        <input type="text" placeholder="Ingrediente" class="flex-1" name="ingredient_name[]">
        <button type="button" onclick="removeIngredient(this)" class="btn btn-outline btn-sm text-red-600 border-red-600">
            Eliminar
        </button>
    </div>
  `
  
  // Reset steps to just one
  stepCounter = 1
  const stepsList = document.getElementById("stepsList")
  stepsList.innerHTML = `
    <div class="step-item p-4 rounded-lg" style="border: 1px solid var(--border-color); background-color: var(--gray-bg);">
        <div class="flex justify-between items-center mb-3">
            <h4 class="font-medium" style="color: var(--primary-color);">Paso 1</h4>
            <button type="button" onclick="removeStep(this)" class="btn btn-outline btn-sm text-red-600 border-red-600">
                Eliminar Paso
            </button>
        </div>
        
        <div class="form-group">
            <label>Descripción del paso</label>
            <textarea name="step_description[]" rows="3" placeholder="Describe detalladamente este paso..." required></textarea>
        </div>
        
        <div class="form-group">
            <label>Foto del paso (opcional)</label>
            <div class="flex items-center gap-4">
                <input type="file" name="step_images[]" accept="image/*" class="hidden" onchange="previewStepImage(this)">
                <button type="button" onclick="this.previousElementSibling.click()" class="btn btn-outline btn-sm">
                    Seleccionar Imagen
                </button>
                <div class="step-image-preview hidden">
                    <img class="w-20 h-20 object-cover rounded-lg" alt="Preview">
                    <button type="button" onclick="removeStepImage(this)" class="text-red-600 text-sm mt-1">Eliminar</button>
                </div>
            </div>
        </div>
    </div>
  `
  
  // Hide final image preview
  document.getElementById('finalImagePreview').classList.add('hidden')
}

// Utility functions
function showToast(message, type = "info") {
  const toast = document.createElement("div")
  toast.className = `toast ${type}`
  
  // Add icon based on type
  const icons = {
    success: '✓',
    error: '✕',
    warning: '⚠',
    info: 'ℹ'
  }
  
  const icon = icons[type] || 'ℹ'
  
  toast.innerHTML = `
    <div style="display: flex; align-items: center; gap: 8px;">
      <span style="font-size: 1.2em; font-weight: bold;">${icon}</span>
      <span>${message}</span>
    </div>
  `

  document.body.appendChild(toast)

  // Show toast with improved animation
  setTimeout(() => {
    toast.classList.add("show")
  }, 100)

  // Hide and remove toast
  setTimeout(() => {
    toast.classList.remove("show")
    setTimeout(() => {
      if (document.body.contains(toast)) {
        document.body.removeChild(toast)
      }
    }, 400)
  }, 4000)
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
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(dateString))
}

function getStatusText(status) {
  const statusTexts = {
    'pendiente': 'Pendiente',
    'aceptado': 'Aceptado',
    'rechazado': 'Rechazado',
    'completado': 'Completado',
    'cancelado': 'Cancelado'
  }
  return statusTexts[status] || status
}

// Service management functions
async function acceptService(serviceId) {
  const confirmed = await showConfirmationModal({
    type: 'accept',
    title: '¿Aceptar Servicio?',
    message: '¿Estás seguro de que quieres aceptar este servicio? El cliente será notificado inmediatamente.',
    confirmText: 'Sí, Aceptar',
    cancelText: 'Cancelar'
  })
  
  if (confirmed) {
    await updateServiceStatus(serviceId, 'aceptado')
  }
}

async function rejectService(serviceId) {
  const motivo = await showInputModal({
    title: 'Rechazar Servicio',
    label: 'Motivo del rechazo (opcional):',
    placeholder: 'Explica brevemente por qué rechazas este servicio...',
    confirmText: 'Continuar',
    cancelText: 'Cancelar'
  })
  
  if (motivo !== null) {
    const confirmed = await showConfirmationModal({
      type: 'reject',
      title: '¿Rechazar Servicio?',
      message: '¿Estás seguro de que quieres rechazar este servicio? Esta acción no se puede deshacer.',
      confirmText: 'Sí, Rechazar',
      cancelText: 'Cancelar'
    })
    
    if (confirmed) {
      await updateServiceStatus(serviceId, 'rechazado', motivo)
    }
  }
}

async function completeService(serviceId) {
  const confirmed = await showConfirmationModal({
    type: 'accept',
    title: '¿Marcar como Completado?',
    message: '¿Confirmas que el servicio ha sido completado satisfactoriamente?',
    confirmText: 'Sí, Completado',
    cancelText: 'Cancelar'
  })
  
  if (confirmed) {
    await updateServiceStatus(serviceId, 'completado')
  }
}

async function cancelService(serviceId) {
  const motivo = await showInputModal({
    title: 'Cancelar Servicio',
    label: 'Motivo de la cancelación (opcional):',
    placeholder: 'Explica brevemente por qué cancelas este servicio...',
    confirmText: 'Continuar',
    cancelText: 'Cancelar'
  })
  
  if (motivo !== null) {
    const confirmed = await showConfirmationModal({
      type: 'cancel',
      title: '¿Cancelar Servicio?',
      message: '¿Estás seguro de que quieres cancelar este servicio? El cliente será notificado.',
      confirmText: 'Sí, Cancelar',
      cancelText: 'No Cancelar'
    })
    
    if (confirmed) {
      await updateServiceStatus(serviceId, 'cancelado', motivo)
    }
  }
}

async function updateServiceStatus(serviceId, estado, motivo = null) {
  try {
    const response = await fetch('api/services/chef-services.php', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      },
      body: JSON.stringify({
        service_id: serviceId,
        estado: estado,
        motivo: motivo
      })
    })
    
    const result = await response.json()
    
    if (result.success) {
      showToast('Estado del servicio actualizado correctamente', 'success')
      loadServices() // Recargar servicios
    } else {
      showToast(result.message || 'Error al actualizar el servicio', 'error')
    }
  } catch (error) {
    console.error('Error updating service status:', error)
    showToast('Error al actualizar el servicio', 'error')
  }
}

// Calendar view for services
function displayServicesCalendar() {
  const calendarContainer = document.getElementById('servicesCalendar')
  if (!calendarContainer) return
  
  // Group services by date
  const servicesByDate = {}
  services.forEach(service => {
    const date = service.fecha_servicio
    if (!servicesByDate[date]) {
      servicesByDate[date] = []
    }
    servicesByDate[date].push(service)
  })
  
  // Generate calendar HTML
  let calendarHTML = '<div class="calendar-grid">'
  
  // Get current month dates
  const today = new Date()
  const currentMonth = today.getMonth()
  const currentYear = today.getFullYear()
  const firstDay = new Date(currentYear, currentMonth, 1)
  const lastDay = new Date(currentYear, currentMonth + 1, 0)
  
  // Calendar header
  calendarHTML += `
    <div class="calendar-header mb-4">
      <h4 class="text-lg font-semibold" style="color: var(--primary-color);">
        ${firstDay.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' })}
      </h4>
    </div>
  `
  
  // Days of week
  const daysOfWeek = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb']
  calendarHTML += '<div class="grid grid-cols-7 gap-1 mb-2">'
  daysOfWeek.forEach(day => {
    calendarHTML += `<div class="text-center text-sm font-medium p-2" style="color: var(--text-light);">${day}</div>`
  })
  calendarHTML += '</div>'
  
  // Calendar days
  calendarHTML += '<div class="grid grid-cols-7 gap-1">'
  
  // Empty cells for days before month starts
  const startDay = firstDay.getDay()
  for (let i = 0; i < startDay; i++) {
    calendarHTML += '<div class="calendar-day empty"></div>'
  }
  
  // Days of the month
  for (let day = 1; day <= lastDay.getDate(); day++) {
    const dateStr = `${currentYear}-${String(currentMonth + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
    const dayServices = servicesByDate[dateStr] || []
    const isToday = day === today.getDate() && currentMonth === today.getMonth() && currentYear === today.getFullYear()
    
    calendarHTML += `
      <div class="calendar-day ${isToday ? 'today' : ''} ${dayServices.length > 0 ? 'has-services' : ''}" 
           onclick="showDayServices('${dateStr}')">
        <div class="day-number">${day}</div>
        ${dayServices.length > 0 ? `<div class="service-count">${dayServices.length}</div>` : ''}
      </div>
    `
  }
  
  calendarHTML += '</div></div>'
  
  calendarContainer.innerHTML = calendarHTML
}

function showDayServices(date) {
  const dayServices = services.filter(service => service.fecha_servicio === date)
  
  if (dayServices.length === 0) {
    showToast('No hay servicios programados para este día', 'info')
    return
  }
  
  let servicesHTML = `
    <div class="day-services-modal">
      <h4 class="text-lg font-semibold mb-4" style="color: var(--primary-color);">
        Servicios del ${formatDate(date)}
      </h4>
      <div class="space-y-3">
  `
  
  dayServices.forEach(service => {
    servicesHTML += `
      <div class="p-3 rounded-lg" style="background-color: var(--gray-bg); border: 1px solid var(--border-color);">
        <div class="flex justify-between items-start">
          <div>
            <h5 class="font-medium" style="color: var(--primary-color);">${service.cliente_nombre}</h5>
            <p class="text-sm" style="color: var(--text-light);">${service.hora_servicio} - ${service.ubicacion_servicio}</p>
            <p class="text-sm" style="color: var(--text-light);">Comensales: ${service.numero_comensales}</p>
          </div>
          <div class="text-right">
            <span class="status-badge status-${service.estado}">${getStatusText(service.estado)}</span>
            <p class="text-sm font-medium" style="color: var(--accent-color);">${formatCurrency(service.precio_total)}</p>
          </div>
        </div>
        <div class="mt-2">
          <button onclick="viewServiceDetails(${service.id}); closeModal('dayServicesModal')" class="btn btn-outline btn-sm">
            Ver Detalles
          </button>
        </div>
      </div>
    `
  })
  
  servicesHTML += `
      </div>
      <div class="mt-4 text-center">
        <button onclick="closeModal('dayServicesModal')" class="btn btn-outline">
          Cerrar
        </button>
      </div>
    </div>
  `
  
  // Create and show modal
  const modal = document.createElement('div')
  modal.id = 'dayServicesModal'
  modal.className = 'modal'
  modal.innerHTML = `
    <div class="modal-content">
      ${servicesHTML}
    </div>
  `
  
  document.body.appendChild(modal)
  modal.style.display = 'flex'
}

// Services view management
function showServicesView(view) {
  const listView = document.getElementById('servicesListView')
  const calendarView = document.getElementById('servicesCalendarView')
  const listBtn = document.getElementById('listViewBtn')
  const calendarBtn = document.getElementById('calendarViewBtn')
  
  if (view === 'list') {
    listView.classList.remove('hidden')
    calendarView.classList.add('hidden')
    listBtn.style.color = 'var(--primary-color)'
    listBtn.style.borderColor = 'var(--primary-color)'
    calendarBtn.style.color = 'var(--text-light)'
    calendarBtn.style.borderColor = 'transparent'
  } else {
    listView.classList.add('hidden')
    calendarView.classList.remove('hidden')
    calendarBtn.style.color = 'var(--primary-color)'
    calendarBtn.style.borderColor = 'var(--primary-color)'
    listBtn.style.color = 'var(--text-light)'
    listBtn.style.borderColor = 'transparent'
    displayServicesCalendar()
  }
}

// Notifications management
function toggleNotifications() {
  const panel = document.getElementById('notificationsPanel')
  panel.classList.toggle('hidden')
  
  if (!panel.classList.contains('hidden')) {
    loadNotifications()
  }
}

// Load and display notifications
async function loadNotifications() {
  try {
    const response = await fetch('api/notifications/get.php', {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      }
    })
    
    const result = await response.json()
    
    if (result.success) {
      displayNotifications(result.data)
      updateNotificationBadge(result.unread_count)
    }
  } catch (error) {
    console.error('Error loading notifications:', error)
  }
}

function displayNotifications(notifications) {
  const notificationsContainer = document.getElementById('notificationsList')
  if (!notificationsContainer) return
  
  if (notifications.length === 0) {
    notificationsContainer.innerHTML = '<p class="text-center" style="color: var(--text-light);">No hay notificaciones</p>'
    return
  }
  
  notificationsContainer.innerHTML = notifications.map(notification => `
    <div class="notification-item ${notification.leida ? '' : 'unread'}" onclick="markNotificationRead(${notification.id})">
      <div class="flex justify-between items-start">
        <div class="flex-1">
          <h5 class="font-medium" style="color: var(--primary-color);">${notification.titulo}</h5>
          <p class="text-sm" style="color: var(--text-color);">${notification.mensaje}</p>
          <p class="text-xs" style="color: var(--text-light);">${formatDate(notification.fecha_creacion)}</p>
        </div>
        ${!notification.leida ? '<div class="notification-dot"></div>' : ''}
      </div>
    </div>
  `).join('')
}

function updateNotificationBadge(count) {
  const badge = document.getElementById('notificationBadge')
  if (badge) {
    if (count > 0) {
      badge.textContent = count
      badge.style.display = 'block'
    } else {
      badge.style.display = 'none'
    }
  }
}

async function markNotificationRead(notificationId) {
  try {
    await fetch('api/notifications/get.php', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      },
      body: JSON.stringify({ notification_id: notificationId })
    })
    
    loadNotifications() // Reload notifications
  } catch (error) {
    console.error('Error marking notification as read:', error)
  }
}

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

// Custom Modal Functions
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

function showInputModal(options) {
  return new Promise((resolve) => {
    const modal = document.createElement('div')
    modal.className = 'input-modal'
    
    modal.innerHTML = `
      <div class="input-modal-content">
        <h3 class="input-modal-title">${options.title}</h3>
        <div class="input-modal-field">
          <label class="input-modal-label">${options.label}</label>
          <textarea 
            class="input-modal-textarea" 
            placeholder="${options.placeholder || ''}"
            id="inputModalTextarea"
          ></textarea>
        </div>
        <div class="input-modal-actions">
          <button class="confirmation-modal-btn secondary" onclick="closeInputModal(null)">
            ${options.cancelText || 'Cancelar'}
          </button>
          <button class="confirmation-modal-btn primary" onclick="closeInputModal('value')">
            ${options.confirmText || 'Confirmar'}
          </button>
        </div>
      </div>
    `
    
    document.body.appendChild(modal)
    
    // Add close function to window for onclick handlers
    window.closeInputModal = (result) => {
      const value = result === 'value' ? document.getElementById('inputModalTextarea').value : null
      modal.classList.remove('show')
      setTimeout(() => {
        document.body.removeChild(modal)
        delete window.closeInputModal
        resolve(value)
      }, 300)
    }
    
    // Show modal with animation
    setTimeout(() => {
      modal.classList.add('show')
      document.getElementById('inputModalTextarea').focus()
    }, 10)
    
    // Close on backdrop click
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        window.closeInputModal(null)
      }
    })
    
    // Handle Enter key
    document.getElementById('inputModalTextarea').addEventListener('keydown', (e) => {
      if (e.key === 'Enter' && e.ctrlKey) {
        window.closeInputModal('value')
      }
    })
  })
}

function logout() {
  localStorage.removeItem("authToken")
  localStorage.removeItem("userData")
  window.location.href = "index.html"
}