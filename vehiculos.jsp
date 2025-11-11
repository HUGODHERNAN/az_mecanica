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
  <title>AZ Mecánica | Vehículos</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Vehículos</span>
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
  <a href="servicios.jsp">Servicios</a>
  <a class="active">Vehículos</a>
</nav>

<main class="container">

  <!-- ===== Últimos vehículos ===== -->
  <section class="card" id="ultimos">
    <div class="section-head">
      <h2>Tabla de últimos vehículos</h2>
      <a class="btn btn-primary" href="vehiculo-form.jsp?action=create">+ Añadir vehículo</a>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable">
        <colgroup>
          <col style="width:14%"><col style="width:10%"><col style="width:10%">
          <col style="width:10%"><col style="width:8%"><col style="width:10%">
          <col style="width:10%"><col style="width:10%"><col style="width:10%">
          <col style="width:8%"><col style="width:10%">
        </colgroup>
        <thead>
        <tr>
          <th>Cliente</th>
          <th>DNI</th>
          <th>Marca</th>
          <th>Modelo</th>
          <th>Tipo</th>
          <th>Año</th>
          <th>Color</th>
          <th>Combustible</th>
          <th>N. Motor</th>
          <th>Placa</th>
          <th class="ta-center">Acciones</th>
        </tr>
        </thead>
        <tbody>
        <!-- MOCK últimos 4 (con campos de BD) -->
        <tr data-id="1">
          <td>Tyler Joseph</td><td>74581236</td><td>Kia</td><td>Rio</td><td><span class="tag">Sedán</span></td>
          <td>2021</td><td>Rojo</td><td>Gasolina</td><td>V-9879</td><td><strong class="money">C7L-394</strong></td>
          <td class="ta-center">
            <a class="chip" href="vehiculo-form.jsp?action=view&id=1">👁</a>
            <a class="chip" href="vehiculo-form.jsp?action=edit&id=1">✏</a>
            <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
          </td>
        </tr>
        <tr data-id="2">
          <td>Luis Cáceres</td><td>70832144</td><td>Hyundai</td><td>Elantra</td><td><span class="tag">Sedán</span></td>
          <td>2018</td><td>Plata</td><td>Gasolina</td><td>X-1223</td><td><strong class="money">BDP-213</strong></td>
          <td class="ta-center">
            <a class="chip" href="vehiculo-form.jsp?action=view&id=2">👁</a>
            <a class="chip" href="vehiculo-form.jsp?action=edit&id=2">✏</a>
            <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
          </td>
        </tr>
        <tr data-id="3">
          <td>Hernan Soto</td><td>72659411</td><td>Toyota</td><td>Hilux</td><td><span class="tag">Pick-up</span></td>
          <td>2022</td><td>Blanco</td><td>Diésel</td><td>Z-4401</td><td><strong class="money">DNW-407</strong></td>
          <td class="ta-center">
            <a class="chip" href="vehiculo-form.jsp?action=view&id=3">👁</a>
            <a class="chip" href="vehiculo-form.jsp?action=edit&id=3">✏</a>
            <button class="chip danger" onclick="fakeDelete(this)">🗑</button>
          </td>
        </tr>
        <tr data-id="4">
          <td>Ben Canela</td><td>75100233</td><td>Nissan</td><td>Sentra</td><td><span class="tag">Sedán</span></td>
          <td>2016</td><td>Negro</td><td>Gasolina</td><td>Q-8800</td><td><strong class="money">FEX-489</strong></td>
          <td class="ta-center">
            <a class="chip" href="vehiculo-form.jsp?action=view&id=4">👁</a>
            <a class="chip" href="vehiculo-form.jsp?action=edit&id=4">✏</a>
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
      <h2>Historial de vehículos</h2>
      <div class="filters">
        <div class="field"><label>Cliente</label><input id="fCliente" type="text" placeholder="Buscar por cliente…"></div>
        <div class="field"><label>Placa</label><input id="fPlaca" type="text" placeholder="Ej: ABC-123"></div>
        <div class="field"><label>Marca</label>
          <select id="fMarca">
            <option value="">Todas</option><option>Kia</option><option>Toyota</option><option>Nissan</option><option>Hyundai</option>
          </select>
        </div>
        <div class="field"><label>Tipo</label>
          <select id="fTipo">
            <option value="">Todos</option><option>Sedán</option><option>SUV</option><option>Pick-up</option><option>Hatchback</option>
          </select>
        </div>
        <div class="field"><label>Desde</label><input id="fDesde" type="date"></div>
        <div class="field"><label>Hasta</label><input id="fHasta" type="date"></div>
        <button class="btn btn-primary" id="btnAplicar">Aplicar filtro</button>
        <button class="btn btn-outline" id="btnLimpiar">Limpiar</button>
      </div>
    </div>

    <div class="datatable-wrapper">
      <table class="datatable" id="tablaHistorial" data-empty="No hay vehículos para el filtro.">
        <thead>
        <tr>
          <th>Cliente</th><th>DNI</th><th>Marca</th><th>Modelo</th><th>Tipo</th>
          <th>Año</th><th>Color</th><th>Combustible</th><th>Kilometraje</th>
          <th>N. Motor</th><th>SOAT</th><th>Tarjeta Prop.</th><th>Placa</th>
          <th class="ta-center">Acciones</th>
        </tr>
        </thead>
        <tbody id="bodyHistorial"></tbody>
      </table>
    </div>
  </section>
</main>

<footer class="footer">© 2025, azmecanicav1 – contacto@az.com</footer>

<script>
// ------- MOCK DATA -------
// Alineado a tu BD: agrega combustible, num_motor, kilometraje, soat, tarjeta_propietario, dni_usuario
const vehiculos = [
  {id:1, cliente:'Tyler Joseph',  dni_usuario:'74581236', marca:'Kia',     modelo:'Rio',      tipo:'Sedán',    anio:2021, color:'Rojo',   combustible:'Gasolina', num_motor:'V-9879', kilometraje:25400, soat:'Vigente',      tarjeta_propietario:'TP-001', placa:'C7L-394', fecha:'2025-02-03'},
  {id:2, cliente:'Luis Cáceres',  dni_usuario:'70832144', marca:'Hyundai', modelo:'Elantra',  tipo:'Sedán',    anio:2018, color:'Plata',  combustible:'Gasolina', num_motor:'X-1223', kilometraje:61200, soat:'Vence 2025', tarjeta_propietario:'TP-002', placa:'BDP-213', fecha:'2025-01-27'},
  {id:3, cliente:'Hernan Soto',   dni_usuario:'72659411', marca:'Toyota',  modelo:'Hilux',    tipo:'Pick-up',  anio:2022, color:'Blanco', combustible:'Diésel',  num_motor:'Z-4401', kilometraje:17800, soat:'Vigente',      tarjeta_propietario:'TP-003', placa:'DNW-407', fecha:'2025-01-26'},
  {id:4, cliente:'Ben Canela',    dni_usuario:'75100233', marca:'Nissan',  modelo:'Sentra',   tipo:'Sedán',    anio:2016, color:'Negro',  combustible:'Gasolina', num_motor:'Q-8800', kilometraje:98000, soat:'Vencido',      tarjeta_propietario:'TP-004', placa:'FEX-489', fecha:'2025-01-24'},
  {id:5, cliente:'Claudia Rojas', dni_usuario:'70445522', marca:'Kia',     modelo:'Sportage', tipo:'SUV',      anio:2020, color:'Azul',   combustible:'GNV',      num_motor:'M-2233', kilometraje:40120, soat:'Vigente',      tarjeta_propietario:'TP-005', placa:'V4S-220', fecha:'2024-12-14'},
  {id:6, cliente:'Diego Núñez',   dni_usuario:'73211009', marca:'Toyota',  modelo:'Yaris',    tipo:'Hatchback',anio:2019, color:'Gris',   combustible:'GLP',      num_motor:'K-7711', kilometraje:51200, soat:'Vigente',      tarjeta_propietario:'TP-006', placa:'CSS-101', fecha:'2024-11-09'}
];

function render(rows){
  const tbody = document.getElementById('bodyHistorial');
  tbody.innerHTML = '';
  rows.forEach(function(r){
    const tr = document.createElement('tr');
    tr.innerHTML =
      '  <td>' + r.cliente + '</td>' +
      '  <td>' + (r.dni_usuario || '') + '</td>' +
      '  <td>' + r.marca + '</td>' +
      '  <td>' + r.modelo + '</td>' +
      '  <td><span class="tag">' + r.tipo + '</span></td>' +
      '  <td>' + r.anio + '</td>' +
      '  <td>' + r.color + '</td>' +
      '  <td>' + (r.combustible || '') + '</td>' +
      '  <td>' + (r.kilometraje != null ? r.kilometraje : '') + '</td>' +
      '  <td>' + (r.num_motor || '') + '</td>' +
      '  <td>' + (r.soat || '') + '</td>' +
      '  <td>' + (r.tarjeta_propietario || '') + '</td>' +
      '  <td><strong class="money">' + r.placa + '</strong></td>' +
      '  <td class="ta-center">' +
      '    <a class="chip" href="vehiculo-form.jsp?action=view&id=' + r.id + '">👁</a>' +
      '    <a class="chip" href="vehiculo-form.jsp?action=edit&id=' + r.id + '">✏</a>' +
      '    <button class="chip danger" onclick="fakeDelete(this)">🗑</button>' +
      '  </td>';
    tbody.appendChild(tr);
  });

  if(rows.length === 0){
    const tr = document.createElement('tr');
    tr.innerHTML = '<td colspan="14" class="empty">' +
      document.getElementById('tablaHistorial').dataset.empty +
      '</td>';
    tbody.appendChild(tr);
  }
}
function applyFilter(){
  const qCli = document.getElementById('fCliente').value.toLowerCase().trim();
  const qPlaca = document.getElementById('fPlaca').value.toLowerCase().trim();
  const marca = document.getElementById('fMarca').value;
  const tipo = document.getElementById('fTipo').value;
  const d = document.getElementById('fDesde').value;
  const h = document.getElementById('fHasta').value;

  const rows = vehiculos.filter(v=>{
    const byCli   = v.cliente.toLowerCase().includes(qCli);
    const byPlaca = v.placa.toLowerCase().includes(qPlaca);
    const byMarca = !marca || v.marca===marca;
    const byTipo  = !tipo  || v.tipo===tipo;
    const byFecha = (!d || v.fecha>=d) && (!h || v.fecha<=h);
    return byCli && byPlaca && byMarca && byTipo && byFecha;
  });
  render(rows);
}
function clearFilter(){
  ['fCliente','fPlaca','fMarca','fTipo','fDesde','fHasta'].forEach(id=>document.getElementById(id).value='');
  render(vehiculos);
}
function fakeDelete(btn){
  const tr=btn.closest('tr'); tr.classList.add('fade'); setTimeout(()=>tr.remove(),200);
}

document.getElementById('btnAplicar').addEventListener('click', applyFilter);
document.getElementById('btnLimpiar').addEventListener('click', clearFilter);
render(vehiculos);
</script>

</body>
</html>
