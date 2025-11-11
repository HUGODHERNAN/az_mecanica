<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
  String rolGuard = (String) session.getAttribute("rol");
  if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | Servicios</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Servicios</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>

<nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a href="citas.jsp">Citas</a>
  <a href="clientes.jsp">Clientes</a>
  <a href="inventario.jsp">Inventario</a>
  <a>Productos</a>
  <a>Registro de Pagos</a>
  <a class="active">Servicios</a>
  <a href="vehiculos.jsp">Vehículos</a>
</nav>

<main class="container">

  <div class="az-toolbar">
    <ul class="az-chips">
      <li><span class="az-chip az-chip--muted">Catálogo de servicios</span></li>
    </ul>

    <!-- Botón que VA a la página de formulario -->
    <a href="servicio-form.jsp?action=create" class="btn btn-primary btn-round">+ Añadir Servicio</a>
  </div>

  <div class="az-tablewrap">
    <table class="table flat">
      <thead>
        <tr>
          <th>Nombre</th>
          <th>Categoría</th>
          <th>Tipo</th>
          <th>Precio min.</th>
          <th>Precio máx.</th>
          <th>Activo</th>
          <th class="center">Acciones</th>
        </tr>
      </thead>
      <tbody>
        <!-- Espera un atributo request "servicios" = List<Servicio> -->
        <c:forEach var="srv" items="${servicios}">
          <tr>
            <td>${srv.nombre}</td>
            <td><span class="tag">${srv.categoria}</span></td>
            <td>${srv.tipo}</td>
            <td>S/ <fmt:formatNumber value="${srv.precio_estimado_min}" minFractionDigits="2" /></td>
            <td>S/ <fmt:formatNumber value="${srv.precio_estimado_max}" minFractionDigits="2" /></td>
            <td>
              <c:choose>
                <c:when test="${srv.activo == 1 || srv.activo == '1'}"><span class="tag">Sí</span></c:when>
                <c:otherwise><span class="tag danger">No</span></c:otherwise>
              </c:choose>
            </td>
            <td class="center">
              <!-- Editar: que el Servlet cargue y reenvíe a servicio-form.jsp con el objeto -->
              <a class="chip" href="ServicioServlet?action=edit&id=${srv.id_servicio}" title="Editar">✏️</a>

              <!-- Eliminar (POST) -->
              <form method="post" action="ServicioServlet" style="display:inline">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="${srv.id_servicio}">
                <button class="chip danger" onclick="return confirm('¿Eliminar este servicio?')">🗑️</button>
              </form>
            </td>
          </tr>
        </c:forEach>

        <c:if test="${empty servicios}">
          <tr><td colspan="7" class="center muted">Sin registros</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

</body>
</html>
