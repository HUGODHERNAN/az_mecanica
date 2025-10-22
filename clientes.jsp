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
  <title>AZ Mecánica | Clientes</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">

  
</head>
<body class="bg">

<!-- TOP -->
<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Clientes</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>

<!-- NAV -->
<nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a>Registro de Pagos</a>
  <a>Productos</a>
  <a>Inventario</a>
  <a>OTs</a>
  <a>Servicios</a>
  <a class="active">Clientes</a>
  <a>Vehículos</a>
</nav>

<main class="container">

  <!-- ===== Últimos clientes ===== -->
  <section class="card" id="ultimos">
    <div class="section-head">
      <h2>Tabla de últimos clientes</h2>
      <a class="btn btn-primary" href="cliente-form.jsp?action=create">+ Registrar cliente</a>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable">
        <colgroup>
          <col style="width:18%"><col style="width:12%"><col style="width:12%">
          <col style="width:12%"><col style="width:14%"><col style="width:12%">
          <col style="width:12%"><col style="width:8%">
        </colgroup>
        <thead>
          <tr>
            <th>Cliente</th>
            <th>Origen</th>
            <th>N° Ref.</th>
            <th>Placa</th>
            <th>Fecha</th>
            <th>Monto</th>
            <th>Método</th>
            <th class="ta-center">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr data-id="1">
            <td>Tyler Joseph</td><td><span class="tag">Orden</span></td><td>OR-0234</td><td>C7L-394</td>
            <td>03/02/2025</td><td><span class="money">S/ 235</span></td><td>Efectivo</td>
            <td class="ta-center">
              <a class="chip" title="Ver"   href="cliente-form.jsp?action=view&id=1">👁</a>
              <a class="chip" title="Editar" href="cliente-form.jsp?action=edit&id=1">✏</a>
              <button class="chip danger" title="Eliminar" onclick="fakeDelete(this)">🗑</button>
            </td>
          </tr>
          <tr data-id="2">
            <td>Luis Cáceres</td><td><span class="tag">Proforma</span></td><td>PF-1045</td><td>BDP-213</td>
            <td>27/01/2025</td><td><span class="money">S/ 198</span></td><td>Tarjeta</td>
            <td class="ta-center">
              <a class="chip" href="cliente-form.jsp?action=view&id=2">👁</a>
              <a class="chip" href="cliente-form.jsp?action=edit&id=2">✏</a>
              <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
            </td>
          </tr>
          <tr data-id="3">
            <td>Hernan Soto</td><td><span class="tag">Proforma</span></td><td>PF-1064</td><td>DNW-407</td>
            <td>26/01/2025</td><td><span class="money">S/ 156</span></td><td>Efectivo</td>
            <td class="ta-center">
              <a class="chip" href="cliente-form.jsp?action=view&id=3">👁</a>
              <a class="chip" href="cliente-form.jsp?action=edit&id=3">✏</a>
              <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
            </td>
          </tr>
          <tr data-id="4">
            <td>Ben Canela</td><td><span class="tag">Orden</span></td><td>OR-0239</td><td>FEX-489</td>
            <td>24/01/2025</td><td><span class="money">S/ 90</span></td><td>Yape</td>
            <td class="ta-center">
              <a class="chip" href="cliente-form.jsp?action=view&id=4">👁</a>
              <a class="chip" href="cliente-form.jsp?action=edit&id=4">✏</a>
              <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="center mt-16">
      <a class="btn btn-secondary" href="#historial">Ver más</a>
    </div>
  </section>

  <!-- ===== Historial + filtros ===== -->
  <section class="card" id="historial">
    <div class="section-head">
      <h2>Historial de clientes</h2>
      <div class="filters">
        <div class="field"><label>Cliente</label><input id="fNombre" type="text" placeholder="Buscar por nombre…"></div>
        <div class="field">
          <label>Origen</label>
          <select id="fOrigen"><option value="">Todos</option><option>Orden</option><option>Proforma</option><option>Web</option></select>
        </div>
        <div class="field"><label>Desde</label><input id="fDesde" type="date"></div>
        <div class="field"><label>Hasta</label><input id="fHasta" type="date"></div>
        <button class="btn btn-primary" id="btnAplicar">Aplicar filtro</button>
        <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
      </div>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable" id="tablaHistorial" data-empty="No hay registros para el filtro.">
        <thead>
          <tr>
            <th>Cliente</th><th>Origen</th><th>N° Ref.</th><th>Placa</th>
            <th>Fecha</th><th>Monto</th><th>Método</th><th class="ta-center">Acciones</th>
          </tr>
        </thead>
        <tbody id="bodyHistorial"></tbody>
      </table>
    </div>
  </section>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

<script>
/* ------- Datos MOCK para historial ------- */
const data = [
  {id:1,nombre:'Tyler Joseph',   origen:'Orden',    ref:'OR-0234', placa:'C7L-394', fecha:'2025-02-03', monto:235, metodo:'Efectivo'},
  {id:2,nombre:'Luis Cáceres',   origen:'Proforma', ref:'PF-1045', placa:'BDP-213', fecha:'2025-01-27', monto:198, metodo:'Tarjeta'},
  {id:3,nombre:'Hernan Soto',    origen:'Proforma', ref:'PF-1064', placa:'DNW-407', fecha:'2025-01-26', monto:156, metodo:'Efectivo'},
  {id:4,nombre:'Ben Canela',     origen:'Orden',    ref:'OR-0239', placa:'FEX-489', fecha:'2025-01-24', monto: 90, metodo:'Yape'},
  {id:5,nombre:'Claudia Rojas',  origen:'Web',      ref:'WB-8842', placa:'V4S-220', fecha:'2024-12-14', monto:320, metodo:'Tarjeta'},
  {id:6,nombre:'Diego Núñez',    origen:'Orden',    ref:'OR-0177', placa:'CSS-101', fecha:'2024-11-09', monto:145, metodo:'Efectivo'}
];

function render(rows){
  const tbody = document.getElementById('bodyHistorial');
  tbody.innerHTML = '';
  rows.forEach(r=>{
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${r.nombre}</td>
      <td><span class="tag">${r.origen}</span></td>
      <td>${r.ref}</td>
      <td>${r.placa}</td>
      <td>${r.fecha}</td>
      <td><span class="money">S/ ${r.monto}</span></td>
      <td>${r.metodo}</td>
      <td class="ta-center">
        <a class="chip" href="cliente-form.jsp?action=view&id=${r.id}">👁</a>
        <a class="chip" href="cliente-form.jsp?action=edit&id=${r.id}">✏</a>
        <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
      </td>`;
    tbody.appendChild(tr);
  });
  if(rows.length===0){
    const tr = document.createElement('tr'); /* <- BUG resuelto (antes estaba 'ttr') */
    tr.innerHTML = '<td colspan="8" class="empty">' + document.getElementById('tablaHistorial').dataset.empty + '</td>';
    tbody.appendChild(tr);
  }
}

function applyFilter(){
  const q = document.getElementById('fNombre').value.toLowerCase().trim();
  const origen = document.getElementById('fOrigen').value;
  const d = document.getElementById('fDesde').value;
  const h = document.getElementById('fHasta').value;
  const rows = data.filter(r=>{
    const byName  = r.nombre.toLowerCase().includes(q);
    const byOrigen= !origen || r.origen===origen;
    const byFecha = (!d || r.fecha>=d) && (!h || r.fecha<=h);
    return byName && byOrigen && byFecha;
  });
  render(rows);
}
function clearFilter(){
  document.getElementById('fNombre').value='';
  document.getElementById('fOrigen').value='';
  document.getElementById('fDesde').value='';
  document.getElementById('fHasta').value='';
  render(data);
}
function fakeDelete(btn){
  const tr = btn.closest('tr');
  tr.classList.add('fade');
  setTimeout(()=>tr.remove(), 200);
}
document.getElementById('btnAplicar').addEventListener('click', applyFilter);
document.getElementById('btnLimpiar').addEventListener('click', clearFilter);
render(data);
</script>
</body>
</html>
