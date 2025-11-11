<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
  <title>AZ Mecánica | Cita</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body>
<header class="topbar">
  <nav class="tabs">
    <a href="citas.jsp" class="active">← Volver a Citas</a>
  </nav>
</header>

<main class="container narrow">
  <h2>
    <c:choose>
      <c:when test="${empty param.id}">Nueva Cita</c:when>
      <c:otherwise>Editar Cita #${param.id}</c:otherwise>
    </c:choose>
  </h2>

  <!-- Se espera en request: 'cita' (puede ser null), 'clientes', 'listaServicios' -->
  <form class="card" method="post" action="CitaServlet" id="formCita">
    <!-- backend: usa 'create'/'update' y campo PK id_cita -->
    <input type="hidden" name="action" value="${empty param.id ? 'create' : 'update'}"/>
    <input type="hidden" name="id_cita" value="${param.id}"/>

    <!-- Campo real para la BD (fecha y hora combinadas) -->
    <input type="hidden" name="fecha_hora" id="fecha_hora" value="${cita.fecha_hora}"/>

    <div class="az-grid2">
      <div class="field">
        <label>Cliente</label>
        <select name="cliente_id" id="cliente_id" required>
          <option value="">Seleccione</option>
          <c:forEach var="cli" items="${clientes}">
            <option value="${cli.cliente_id}"
                    ${cli.cliente_id==cita.cliente_id?'selected':''}>
              ${cli.nombre} ${cli.apellido}
            </option>
          </c:forEach>
        </select>
      </div>

      <div class="field">
        <label>Vehículo (placa)</label>
        <select name="placa" id="placa" required>
          <option value="">Seleccione un cliente</option>
        </select>
      </div>
    </div>

    <div class="az-grid3">
      <div class="field">
        <label>Fecha</label>
        <!-- si vienes con fecha_hora, puedes parsearla en el servlet y setear 'cita.fecha' y 'cita.hora' -->
        <input type="date" id="fecha" required value="${cita.fecha}">
      </div>
      <div class="field">
        <label>Hora</label>
        <input type="time" id="hora" required value="${cita.hora}">
      </div>
      <div class="field">
        <label>Estado</label>
        <select name="estado" required>
          <option value="PENDIENTE"   ${cita.estado=='PENDIENTE'?'selected':''}>Pendiente</option>
          <option value="CONFIRMADA"  ${cita.estado=='CONFIRMADA'?'selected':''}>Confirmada</option>
          <option value="ATENDIDA"    ${cita.estado=='ATENDIDA'?'selected':''}>Atendida</option>
          <option value="CANCELADA"   ${cita.estado=='CANCELADA'?'selected':''}>Cancelada</option>
        </select>
      </div>
    </div>

    <div class="field">
      <label>Servicio</label>
      <select name="id_servicio" id="id_servicio" required>
        <option value="">Seleccione</option>
        <c:forEach var="s" items="${listaServicios}">
          <option value="${s.id_servicio}" ${s.id_servicio==cita.id_servicio?'selected':''}>
            ${s.nombre}
          </option>
        </c:forEach>
      </select>
    </div>

    <div class="field">
      <label>Notas</label>
      <textarea name="notas" rows="3">${cita.notas}</textarea>
    </div>

    <footer class="actions end">
      <a class="btn" href="citas.jsp">Cancelar</a>
      <button class="btn btn-primary" type="submit">Guardar</button>
    </footer>
  </form>
</main>

<script>
  const selCliente = document.getElementById('cliente_id');
  const selPlaca   = document.getElementById('placa');
  const selectedPlaca = '<c:out value="${cita.placa}"/>' || '';
  const form = document.getElementById('formCita');
  const inpFecha = document.getElementById('fecha');
  const inpHora  = document.getElementById('hora');
  const hiddenFechaHora = document.getElementById('fecha_hora');

  async function cargarVehiculos(clienteId) {
    selPlaca.innerHTML = '<option value="">Cargando...</option>';
    if (!clienteId) { selPlaca.innerHTML = '<option value="">Seleccione un cliente</option>'; return; }
    try {
      // Debe devolver: [{placa: 'ABC-123', marca:'Toyota', modelo:'Yaris'}]
      const res = await fetch(`VehiculoServlet?action=listByCliente&cliente_id=\${encodeURIComponent(idCliente)}`);
      const data = await res.json();
      selPlaca.innerHTML = '<option value="">Seleccione</option>';
      data.forEach(v => {
        const opt = document.createElement('option');
        opt.value = v.placa;                       // PK real
        opt.textContent = v.placa + (v.modelo ? (' - ' + v.modelo) : '');
        if (selectedPlaca && String(v.placa) === String(selectedPlaca)) opt.selected = true;
        selPlaca.appendChild(opt);
      });
    } catch (e) {
      selPlaca.innerHTML = '<option value="">Error al cargar</option>';
    }
  }

  // Combina fecha + hora en el formato "YYYY-MM-DDTHH:mm" esperado para timestamp
  function armarFechaHora() {
    const f = inpFecha.value; // 'YYYY-MM-DD'
    const h = inpHora.value;  // 'HH:mm'
    hiddenFechaHora.value = (f && h) ? `${f}T${h}:00` : '';
  }

  selCliente.addEventListener('change', e => cargarVehiculos(e.target.value));
  form.addEventListener('submit', (e) => {
    armarFechaHora();
    if (!hiddenFechaHora.value) {
      e.preventDefault();
      alert('Completa fecha y hora.');
    }
  });

  // precarga si viene seleccionado
  if (selCliente.value) cargarVehiculos(selCliente.value);
  // inicial: si fecha_hora vino lleno, puedes descomponerlo en el backend.
</script>
</body>
</html>
