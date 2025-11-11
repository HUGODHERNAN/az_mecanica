<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
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
  <title>AZ Mecánica | Inventario</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Inventario</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>

<nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a href="citas.jsp">Citas</a>
  <a href="clientes.jsp">Clientes</a>
  <a class="active">Inventario</a>
  <a>Productos</a>
  <a>Registro de Pagos</a>
  <a href="servicios.jsp">Servicios</a>
  <a href="vehiculos.jsp">Vehículos</a>
</nav>

<main class="container">
  <section class="card" id="ultimos">
    <div class="section-head">
      <h2>Inventario de productos</h2>
      <a class="btn btn-primary" href="inventario-form.jsp?action=create">+ Agregar producto</a>
    </div>

    <div class="filters" style="margin-bottom:.5rem">
      <div class="field">
        <label>Código</label>
        <input id="fCodigo" type="text" placeholder="P0001, F0010…">
      </div>
      <div class="field">
        <label>Nombre</label>
        <input id="fNombre" type="text" placeholder="Buscar por nombre…">
      </div>
      <div class="field">
        <label>Categoría</label>
        <select id="fCategoria">
          <option value="">Todas</option>
          <option>Lubricantes</option><option>Filtros</option><option>Eléctricos</option>
          <option>Llantas</option><option>Motor</option><option>Hules</option><option>Otros</option>
        </select>
      </div>
      <button class="btn btn-primary" id="btnAplicar">Aplicar filtro</button>
      <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable" id="tablaInv" data-empty="No hay productos para el filtro.">
        <colgroup>
          <col style="width:10%"><col style="width:24%"><col style="width:12%">
          <col style="width:8%"><col style="width:8%"><col style="width:10%">
          <col style="width:10%"><col style="width:8%"><col style="width:10%">
        </colgroup>
        <thead>
          <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Categoría</th>
            <th>UM</th>
            <th>Stock</th>
            <th>Stock mín.</th>
            <th>Precio</th>
            <th>Activo</th>
            <th class="ta-center">Acciones</th>
          </tr>
        </thead>
        <tbody id="bodyInv"></tbody>
      </table>
    </div>
  </section>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

<!-- EJEMPLOS implementados-->
<script>
const productos = [
  { id_producto:1, codigo:'P0001', nombre:'Aceite de motor 10W-40', categoria:'Lubricantes', um:'litro',  stock:11, stock_minimo:3, precio:19.90, activo:1 },
  { id_producto:2, codigo:'P0002', nombre:'Filtro de aire Toyota Yaris', categoria:'Filtros',     um:'unidad', stock:4,  stock_minimo:3, precio:15.00, activo:1 },
  { id_producto:3, codigo:'P0003', nombre:'Pastillas de freno delanteras', categoria:'Hules',      um:'juego',  stock:2,  stock_minimo:3, precio:39.50, activo:1 }
];

function renderInv(rows){
  const tb = document.getElementById('bodyInv');
  tb.innerHTML = '';
  rows.forEach(function(p){
    const low = Number(p.stock) <= Number(p.stock_minimo);
    const tr = document.createElement('tr');
    if (low) tr.style.background = '#1a1416';

    tr.innerHTML =
      '<td>'+p.codigo+'</td>' +
      '<td>'+p.nombre + (low ? ' <span class="icon danger" title="Stock por debajo del mínimo">❗</span>' : '') + '</td>' +
      '<td><span class="tag">'+p.categoria+'</span></td>' +
      '<td>'+(p.um || '-')+'</td>' +
      '<td>'+p.stock+'</td>' +
      '<td>'+p.stock_minimo+'</td>' +
      '<td><span class="money">S/ '+Number(p.precio||0).toFixed(2)+'</span></td>' +
      '<td>'+(String(p.activo)==='1' ? '<span class="tag">Sí</span>' : '<span class="tag danger">No</span>')+'</td>' +
      '<td class="ta-center">' +
        '<a class="chip" href="inventario-form.jsp?action=view&id='+p.id_producto+'" title="Ver">👁</a>' +
        '<a class="chip" href="inventario-form.jsp?action=edit&id='+p.id_producto+'" title="Editar">✏</a>' +
        '<a class="chip" href="inventario-mov-form.jsp?action=create&id_producto='+p.id_producto+'" title="Movimientos">↕</a>' +
        '<button class="chip danger" onclick="fakeDelete('+p.id_producto+')" title="Eliminar">🗑</button>' +
      '</td>';

    tb.appendChild(tr);
  });

  if(rows.length === 0){
    const tr = document.createElement('tr');
    tr.innerHTML = '<td colspan="9" class="empty">' +
      document.getElementById('tablaInv').dataset.empty + '</td>';
    tb.appendChild(tr);
  }
}

// Eliminar de prueba (sólo front)
function fakeDelete(id){
  const idx = productos.findIndex(p => p.id_producto === id);
  if (idx >= 0) productos.splice(idx, 1);
  renderInv(productos);
}

// Filtros
document.addEventListener('DOMContentLoaded', function(){
  renderInv(productos);

  const fCodigo = document.getElementById('fCodigo');
  const fNombre = document.getElementById('fNombre');
  const fCategoria = document.getElementById('fCategoria');

  document.getElementById('btnAplicar').addEventListener('click', function(){
    const codigo = (fCodigo.value || '').trim().toLowerCase();
    const nombre = (fNombre.value || '').trim().toLowerCase();
    const categoria = (fCategoria.value || '').trim();

    const filtrados = productos.filter(function(p){
      const okCod = !codigo || p.codigo.toLowerCase().includes(codigo);
      const okNom = !nombre || p.nombre.toLowerCase().includes(nombre);
      const okCat = !categoria || p.categoria === categoria;
      return okCod && okNom && okCat;
    });

    renderInv(filtrados);
  });

  document.getElementById('btnLimpiar').addEventListener('click', function(){
    fCodigo.value = '';
    fNombre.value = '';
    fCategoria.value = '';
    renderInv(productos);
  });
});
</script>



</body>
</html>
