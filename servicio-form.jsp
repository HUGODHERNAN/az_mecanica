<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  String rolGuard = (String) session.getAttribute("rol");
  if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
  // action=create | update
  String action = request.getParameter("action");
  if (action == null) action = "create";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | ${action eq 'create' ? 'Nuevo servicio' : 'Editar servicio'}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">${action eq 'create' ? 'Nuevo servicio' : 'Editar servicio'}</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>

<nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a>Registro de Pagos</a>
  <a>Productos</a>
  <a>Inventario</a>
  <a href="citas.jsp">Citas</a>
  <a class="active" href="servicios.jsp">Servicios</a>
  <a href="clientes.jsp">Clientes</a>
  <a href="vehiculos.jsp">Vehículos</a>
</nav>

<main class="container">
  <section class="card">
    <div class="section-head">
      <h2>${action eq 'create' ? 'Registrar servicio' : 'Actualizar servicio'}</h2>
      <a class="btn" href="servicios.jsp">← Volver</a>
    </div>

    <!--
      Espera (para editar) un atributo request "servicio" con campos:
      id_servicio, nombre, categoria, tipo, precio_estimado_min, precio_estimado_max, activo, descripcion (opcional)
    -->
    <form method="post" action="ServicioServlet" class="form">
      <input type="hidden" name="action" value="${action}"/>
      <c:if test="${action eq 'update'}">
        <input type="hidden" name="id_servicio" value="${servicio.id_servicio}"/>
      </c:if>

      <div class="az-grid2">
        <div class="field">
          <label>Nombre del servicio <span class="req">*</span></label>
          <input name="nombre" maxlength="120" required
                 value="${servicio.nombre}"/>
        </div>

        <div class="field">
          <label>Categoría <span class="req">*</span></label>
          <select name="categoria" required>
            <option value="">Seleccione</option>
            <option ${servicio.categoria=='Mecánica' ? 'selected' : ''}>Mecánica</option>
            <option ${servicio.categoria=='Eléctrico' ? 'selected' : ''}>Eléctrico</option>
            <option ${servicio.categoria=='Llantas' ? 'selected' : ''}>Llantas</option>
            <option ${servicio.categoria=='Lubricación' ? 'selected' : ''}>Lubricación</option>
            <option ${servicio.categoria=='Carrocería' ? 'selected' : ''}>Carrocería</option>
            <option ${servicio.categoria=='Otros' ? 'selected' : ''}>Otros</option>
          </select>
        </div>
      </div>

      <div class="az-grid2">
        <div class="field">
          <label>Tipo <span class="req">*</span></label>
          <select name="tipo" required>
            <option value="">Seleccione</option>
            <option ${servicio.tipo=='Mantenimiento' ? 'selected' : ''}>Mantenimiento</option>
            <option ${servicio.tipo=='Diagnóstico' ? 'selected' : ''}>Diagnóstico</option>
            <option ${servicio.tipo=='Correctivo' ? 'selected' : ''}>Correctivo</option>
            <option ${servicio.tipo=='Preventivo' ? 'selected' : ''}>Preventivo</option>
          </select>
        </div>

        <div class="field">
          <label>Activo</label>
          <div class="switch">
            <label class="checkbox">
              <input type="checkbox" name="activo"
                     value="1" ${servicio.activo=='1' || empty servicio ? 'checked' : ''}>
              <span>Disponible</span>
            </label>
          </div>
        </div>
      </div>

      <div class="az-grid2">
        <div class="field">
          <label>Precio estimado (mín) S/</label>
          <input type="number" name="precio_estimado_min" step="0.01" min="0"
                 value="${servicio.precio_estimado_min}"/>
        </div>
        <div class="field">
          <label>Precio estimado (máx) S/</label>
          <input type="number" name="precio_estimado_max" step="0.01" min="0"
                 value="${servicio.precio_estimado_max}"/>
        </div>
      </div>

      <div class="field">
        <label>Descripción</label>
        <textarea name="descripcion" rows="3" maxlength="500">${servicio.descripcion}</textarea>
      </div>

      <footer class="form__actions">
        <a class="btn" href="servicios.jsp">Cancelar</a>
        <button class="btn btn-primary">${action eq 'create' ? 'Guardar' : 'Actualizar'}</button>
      </footer>
    </form>
  </section>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

<!-- Sin usar template literals para evitar choques con EL -->
<script>
  // Validación simple de rangos (cliente)
  (function(){
    var form = document.querySelector('form');
    if (!form) return;
    form.addEventListener('submit', function(e){
      var min = parseFloat(form.precio_estimado_min.value || '0');
      var max = parseFloat(form.precio_estimado_max.value || '0');
      if (min && max && max < min) {
        e.preventDefault();
        alert('El precio máximo no puede ser menor que el mínimo.');
      }
    });
  })();
</script>
</body>
</html>
