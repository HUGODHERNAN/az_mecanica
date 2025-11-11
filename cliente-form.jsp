<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
  <title>AZ Mecánica | Cliente</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
</head>
<body class="bg">
<header class="topbar">
  <div class="brand">
    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
    <span id="title">Registrar cliente</span>
  </div>
  <a class="btn btn-outline" href="clientes.jsp">← Volver</a>
</header>

<main class="container">
  <section class="card narrow">
    <div class="form-title">
      <h2 id="h2title">Registrar cliente</h2>
      <span class="form-badge">Ficha</span>
    </div>

    <!-- Ajusta en tu servlet: action=create/update; usa cliente_id cuando edites -->
    <form id="formCliente" class="form" method="post" action="ClienteServlet">
      <input type="hidden" name="action" value="${empty param.id ? 'create' : 'update'}">
      <input type="hidden" name="cliente_id" value="${param.id}">

      <!-- Datos personales (nombres de columna EXACTOS a la BD) -->
      <div class="row col-6">
        <label class="label">Nombre</label>
        <input class="input" name="nombre" value="${requestScope.cliente.nombre}" required placeholder="Nombre del cliente">
      </div>
      <div class="row col-6">
        <label class="label">Apellido</label>
        <input class="input" name="apellido" value="${requestScope.cliente.apellido}" required placeholder="Apellido del cliente">
      </div>

      <div class="row col-6">
        <label class="label">DNI</label>
        <input class="input" name="dni" value="${requestScope.cliente.dni}" pattern="[0-9]{8}" maxlength="8" placeholder="00000000">
      </div>
      <div class="row col-6">
        <label class="label">Teléfono</label>
        <input class="input" name="telefono" value="${requestScope.cliente.telefono}" placeholder="999888777">
      </div>

      <div class="row col-12">
        <label class="label">Email</label>
        <input class="input" name="email" type="email" value="${requestScope.cliente.email}" placeholder="correo@dominio.com">
      </div>

      <div class="row col-12">
        <label class="label">Dirección</label>
        <input class="input" name="direccion" value="${requestScope.cliente.direccion}" placeholder="Calle, número, barrio">
      </div>

      <!-- NOTA: Origen, Ref, Placa y Método se eliminaron porque NO pertenecen a 'cliente' -->
      <!-- Muévelos a proforma/orden/vehículo/pago según corresponda en tu flujo -->

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">Guardar</button>
        <a class="btn btn-outline" href="clientes.jsp">Cancelar</a>
      </div>
    </form>
  </section>
</main>

<script>
  // Soporte simple para modo crear/editar/ver vía querystring: ?action=view|edit&id=#
  const params = new URLSearchParams(location.search);
  const action = params.get('action') || (document.querySelector('input[name="action"]').value);
  const h2 = document.getElementById('h2title');
  const title = document.getElementById('title');
  const form = document.getElementById('formCliente');

  if (action === 'update' || action === 'edit') {
    h2.textContent = 'Editar cliente';
    title.textContent = 'Editar cliente';
  } else if (action === 'view') {
    h2.textContent = 'Ficha del cliente';
    title.textContent = 'Ficha del cliente';
    [...form.elements].forEach(el => el.disabled = true);
  } else {
    h2.textContent = 'Registrar cliente';
    title.textContent = 'Registrar cliente';
  }
</script>
</body>
</html>
