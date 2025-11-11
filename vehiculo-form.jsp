<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | Vehículo</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body class="bg">

<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Vehículo</span>
    </div>
    <a class="btn btn-outline" href="vehiculos.jsp">← Volver</a>
  </div>
</header>

<main class="container">
  <section class="card narrow">
    <div class="form-title">
      <h2 id="title"><c:out value="${empty vehiculo ? 'Registrar vehículo' : 'Editar vehículo'}"/></h2>
      <span class="form-badge">Ficha</span>
    </div>

    <!-- 
      Espera que el servlet ponga (opcionalmente):
      - request.setAttribute("vehiculo", vehiculoEncontrado); // con getters como en los name=""
      - request.setAttribute("listaClientes", listaClientes); // List<Cliente> con getDni() y getNombreCompleto()
    -->
    <form id="formVehiculo" class="form"
          action="${pageContext.request.contextPath}/VehiculoServlet"
          method="post" autocomplete="off">

      <input type="hidden" name="accion" value="${empty vehiculo ? 'guardar' : 'actualizar'}"/>

      <!-- Relación con usuario/cliente (FK) -->
      <div class="row col-12">
        <label class="label">Cliente (DNI)</label>
        <select class="select" name="dni_usuario" required>
          <option value="">— Selecciona cliente —</option>
          <c:forEach items="${listaClientes}" var="cli">
            <option value="${cli.dni}"
              <c:if test="${not empty vehiculo && vehiculo.dni_usuario == cli.dni}">selected</c:if>>
              ${cli.dni} — ${cli.nombreCompleto}
            </option>
          </c:forEach>
        </select>
        <div class="subtle">Si no aparece, primero registra al cliente.</div>
      </div>

      <!-- Identificadores -->
      <div class="row col-4">
        <label class="label">Placa</label>
        <input class="input" name="placa" required
               pattern="[A-Z0-9-]{6,8}" maxlength="10" placeholder="ABC-123"
               value="<c:out value='${vehiculo.placa}'/>"
               <c:if test='${not empty vehiculo}'>readonly</c:if>>
        <div class="subtle">No se puede editar porque es PK.</div>
      </div>
      <div class="row col-4">
        <label class="label">N. Motor</label>
        <input class="input" name="num_motor" maxlength="50" placeholder="V-9879"
               value="<c:out value='${vehiculo.num_motor}'/>">
      </div>
      <div class="row col-4">
        <label class="label">VIN</label>
        <input class="input" name="vin" maxlength="20" placeholder="17 caracteres"
               value="<c:out value='${vehiculo.vin}'/>">
      </div>

      <!-- Datos del vehículo -->
      <div class="row col-3">
        <label class="label">Marca</label>
        <input class="input" name="marca" maxlength="50" placeholder="Kia / Toyota…"
               value="<c:out value='${vehiculo.marca}'/>" required>
      </div>
      <div class="row col-3">
        <label class="label">Modelo</label>
        <input class="input" name="modelo" maxlength="50" placeholder="Rio / Hilux…"
               value="<c:out value='${vehiculo.modelo}'/>" required>
      </div>
      <div class="row col-3">
        <label class="label">Tipo</label>
        <select class="select" name="tipo" required>
          <c:set var="vt" value="${vehiculo.tipo}"/>
          <option value="">—</option>
          <option ${vt=='Sedán'?'selected':''}>Sedán</option>
          <option ${vt=='SUV'?'selected':''}>SUV</option>
          <option ${vt=='Pick-up'?'selected':''}>Pick-up</option>
          <option ${vt=='Hatchback'?'selected':''}>Hatchback</option>
          <option ${vt=='Van'?'selected':''}>Van</option>
        </select>
      </div>
      <div class="row col-3">
        <label class="label">Año</label>
        <input class="input" name="anio" type="number" min="1970" max="2099" placeholder="2021"
               value="<c:out value='${vehiculo.anio}'/>" required>
      </div>

      <div class="row col-3">
        <label class="label">Color</label>
        <input class="input" name="color" maxlength="30" placeholder="Rojo / Negro…"
               value="<c:out value='${vehiculo.color}'/>">
      </div>
      <div class="row col-3">
        <label class="label">Combustible</label>
        <select class="select" name="combustible">
          <c:set var="vc" value="${vehiculo.combustible}"/>
          <option value="">—</option>
          <option ${vc=='Gasolina'?'selected':''}>Gasolina</option>
          <option ${vc=='Diésel'?'selected':''}>Diésel</option>
          <option ${vc=='GLP'?'selected':''}>GLP</option>
          <option ${vc=='GNV'?'selected':''}>GNV</option>
          <option ${vc=='Eléctrico'?'selected':''}>Eléctrico</option>
        </select>
      </div>
      <div class="row col-3">
        <label class="label">Transmisión</label>
        <select class="select" name="transmision">
          <c:set var="tr" value="${vehiculo.transmision}"/>
          <option value="">—</option>
          <option ${tr=='Mecánica'?'selected':''}>Mecánica</option>
          <option ${tr=='Automática'?'selected':''}>Automática</option>
          <option ${tr=='CVT'?'selected':''}>CVT</option>
        </select>
      </div>
      <div class="row col-3">
        <label class="label">Kilometraje</label>
        <input class="input" name="kilometraje" type="number" min="0" step="1" placeholder="0"
               value="<c:out value='${vehiculo.kilometraje}'/>">
      </div>

      <!-- Documentos -->
      <div class="row col-6">
        <label class="label">SOAT</label>
        <input class="input" name="soat" maxlength="30" placeholder="N° SOAT o estado"
               value="<c:out value='${vehiculo.soat}'/>">
      </div>
      <div class="row col-6">
        <label class="label">Tarjeta de Propiedad</label>
        <input class="input" name="tarjeta_propietario" maxlength="50" placeholder="N° tarjeta"
               value="<c:out value='${vehiculo.tarjeta_propietario}'/>">
      </div>

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">
          <c:out value="${empty vehiculo ? 'Guardar' : 'Actualizar'}"/>
        </button>
        <a class="btn btn-outline" href="vehiculos.jsp">Cancelar</a>
      </div>
    </form>
  </section>
</main>
<script>
// Bloquea edición cuando action=view
(function () {
  var params = new URLSearchParams(window.location.search);
  var action = (params.get('action') || '').toLowerCase();

  if (action === 'view') {
    var form  = document.getElementById('formVehiculo');
    var title = document.getElementById('title');

    if (title) title.textContent = 'Ficha del vehículo';

    if (form) {
      // Deshabilita todos los controles (excepto hidden)
      var controls = form.querySelectorAll('input, select, textarea, button[type="submit"]');
      for (var i = 0; i < controls.length; i++) {
        if (controls[i].type !== 'hidden') {
          controls[i].disabled = true;
        }
      }
      // Oculta Guardar
      var btnSave = form.querySelector('button[type="submit"]');
      if (btnSave) btnSave.style.display = 'none';
      // Cambia "Cancelar" por "Volver"
      var btnBack = form.querySelector('a.btn.btn-outline');
      if (btnBack) btnBack.textContent = 'Volver';
      // Evita submit por si acaso
      form.addEventListener('submit', function (e) { e.preventDefault(); });
    }
  }
})();
</script>

</body>
</html>
