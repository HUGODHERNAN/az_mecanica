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
  <title>AZ Mecánica | Producto</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">
<header class="topbar">
  <div class="brand">
    <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
    <span id="pageTitle"><c:choose><c:when test="${empty param.id}">Registrar producto</c:when><c:otherwise>Editar producto</c:otherwise></c:choose></span>
  </div>
  <a class="btn btn-outline" href="inventario.jsp">← Volver</a>
</header>

<main class="container">
  <section class="card narrow">
    <div class="form-title">
      <h2 id="formTitle"><c:choose><c:when test="${empty param.id}">Registrar producto</c:when><c:otherwise>Editar producto</c:otherwise></c:choose></h2>
      <span class="form-badge">Inventario</span>
    </div>

    <!-- IMPORTANTE: names = columnas reales de la BD -->
    <form id="formProd" class="form" method="post" action="ProductoServlet">
      <input type="hidden" name="action" value="${empty param.id ? 'create' : 'update'}">
      <input type="hidden" name="id_producto" value="${param.id}">

      <div class="row col-4">
        <label class="label">Código</label>
        <input class="input" name="codigo" required placeholder="P0001"
               value="${requestScope.producto.codigo}">
      </div>

      <div class="row col-8">
        <label class="label">Nombre</label>
        <input class="input" name="nombre" required placeholder="Nombre del producto"
               value="${requestScope.producto.nombre}">
      </div>

      <div class="row col-6">
        <label class="label">Categoría</label>
        <select class="select" name="categoria" required>
          <option value="">—</option>
          <option ${requestScope.producto.categoria=='Lubricantes'?'selected':''}>Lubricantes</option>
          <option ${requestScope.producto.categoria=='Filtros'?'selected':''}>Filtros</option>
          <option ${requestScope.producto.categoria=='Eléctricos'?'selected':''}>Eléctricos</option>
          <option ${requestScope.producto.categoria=='Llantas'?'selected':''}>Llantas</option>
          <option ${requestScope.producto.categoria=='Motor'?'selected':''}>Motor</option>
          <option ${requestScope.producto.categoria=='Hules'?'selected':''}>Hules</option>
          <option ${requestScope.producto.categoria=='Otros'?'selected':''}>Otros</option>
        </select>
      </div>

      <div class="row col-3">
        <label class="label">UM</label>
        <!-- unidad de medida -->
        <input class="input" name="um" placeholder="unidad/par/litro"
               value="${requestScope.producto.um}">
      </div>

      <div class="row col-3">
        <label class="label">Precio (S/)</label>
        <input class="input" name="precio" type="number" min="0" step="0.01" required
               value="${empty requestScope.producto.precio ? '0.00' : requestScope.producto.precio}">
      </div>

      <div class="row col-3">
        <label class="label">Stock</label>
        <input class="input" name="stock" type="number" min="0" step="1" required
               value="${empty requestScope.producto.stock ? '0' : requestScope.producto.stock}">
      </div>

      <div class="row col-3">
        <label class="label">Stock mínimo</label>
        <input class="input" name="stock_minimo" type="number" min="0" step="1"
               value="${empty requestScope.producto.stock_minimo ? '3' : requestScope.producto.stock_minimo}">
      </div>

      <div class="row col-6">
        <label class="label">Activo</label>
        <select class="select" name="activo">
          <option value="1" ${requestScope.producto.activo==1?'selected':''}>Sí</option>
          <option value="0" ${requestScope.producto.activo==0?'selected':''}>No</option>
        </select>
      </div>

      <div class="col-12 subtle">
        * Se guardará en <code>producto</code> (codigo, nombre, categoria, precio, um, stock, stock_minimo, activo).
      </div>

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">Guardar</button>
        <a class="btn" href="inventario.jsp">Cancelar</a>
      </div>
    </form>
  </section>
</main>

<script>
  // Aviso si stock <= stock_minimo
  const form = document.getElementById('formProd');
  const warn = document.createElement('div');
  warn.className = 'hint';
  warn.style.cssText = 'color:#ffcc00;font-weight:700;margin-top:.25rem';
  warn.textContent = '⚠ Stock en o por debajo del mínimo. Se generará alerta.';
  function checkWarn(){
    const s = Number(form.stock.value||0);
    const m = Number(form.stock_minimo.value||0);
    if(s <= m && !warn.isConnected) form.stock_minimo.parentElement.appendChild(warn);
    if(s > m && warn.isConnected) warn.remove();
  }
  form.stock.addEventListener('input', checkWarn);
  form.stock_minimo.addEventListener('input', checkWarn);
  checkWarn();
</script>
</body>
</html>
