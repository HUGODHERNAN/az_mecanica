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
  <title>AZ Mecánica | Movimiento de Inventario</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">
<header class="topbar">
  <div class="brand">
    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
    <span>Registrar movimiento</span>
  </div>
  <a class="btn btn-outline" href="inventario.jsp">← Volver</a>
</header>

<main class="container">
  <section class="card narrow">
    <div class="form-title">
      <h2>Movimiento de inventario</h2>
      <span class="form-badge">Kardex</span>
    </div>

    <!-- Espera en request: listaProductos -->
    <form class="form" method="post" action="InventarioMovServlet" id="formMov">
      <input type="hidden" name="action" value="${empty param.id ? 'create' : 'update'}">
      <input type="hidden" name="id_mov" value="${param.id}">

      <div class="row col-8">
        <label class="label">Producto</label>
        <select class="select" name="id_producto" id="id_producto" required>
          <option value="">— Seleccionar —</option>
          <c:forEach items="${listaProductos}" var="p">
            <option value="${p.id_producto}"
                    ${p.id_producto==requestScope.mov.id_producto?'selected':''}>
              ${p.codigo} — ${p.nombre}
            </option>
          </c:forEach>
        </select>
      </div>

      <div class="row col-4">
        <label class="label">Tipo</label>
        <select class="select" name="tipo" id="tipo" required>
          <option ${requestScope.mov.tipo=='IN'?'selected':''}>IN</option>
          <option ${requestScope.mov.tipo=='OUT'?'selected':''}>OUT</option>
          <option ${requestScope.mov.tipo=='AJUSTE'?'selected':''}>AJUSTE</option>
        </select>
      </div>

      <div class="row col-4">
        <label class="label">Cantidad</label>
        <input class="input" name="cantidad" type="number" min="1" step="1" required
               value="${empty requestScope.mov.cantidad ? '' : requestScope.mov.cantidad}">
      </div>

      <div class="row col-4">
        <label class="label">Costo unitario (S/)</label>
        <input class="input" name="costo_unitario" type="number" min="0" step="0.01"
               value="${empty requestScope.mov.costo_unitario ? '' : requestScope.mov.costo_unitario}">
      </div>

      <div class="row col-4">
        <label class="label">Documento ref.</label>
        <input class="input" name="documento_id" placeholder="OC-001 / REP-123"
               value="${requestScope.mov.documento_id}">
      </div>

      <div class="row col-12">
        <label class="label">Notas</label>
        <input class="input" name="notas" value="${requestScope.mov.notas}">
      </div>

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">Guardar</button>
        <a class="btn" href="inventario.jsp">Cancelar</a>
      </div>
    </form>
  </section>
</main>

<script>
  // Validación rápida: evita OUT que deje el stock negativo (el cálculo real hazlo en el backend)
  // Opcionalmente puedes pedir el stock actual vía fetch cuando cambie el producto.
</script>
</body>
</html>
