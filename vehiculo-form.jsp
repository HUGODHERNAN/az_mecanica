<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
      <h2 id="title">Registrar vehículo</h2>
      <span class="form-badge">Ficha</span>
    </div>

    <form id="formVehiculo" class="form">
      <!-- Relación -->
      <div class="row col-12">
        <label class="label">Cliente</label>
        <input class="input" name="cliente" placeholder="Nombre del cliente">
      </div>

      <!-- Datos del vehículo -->
      <div class="row col-3">
        <label class="label">Marca</label>
        <input class="input" name="marca" placeholder="Kia / Toyota…">
      </div>
      <div class="row col-3">
        <label class="label">Modelo</label>
        <input class="input" name="modelo" placeholder="Rio / Hilux…">
      </div>
      <div class="row col-3">
        <label class="label">Tipo</label>
        <select class="select" name="tipo">
          <option value="">—</option>
          <option>Sedán</option><option>SUV</option><option>Pick-up</option><option>Hatchback</option><option>Van</option>
        </select>
      </div>
      <div class="row col-3">
        <label class="label">Año</label>
        <input class="input" name="anio" type="number" min="1970" max="2099" placeholder="2021">
      </div>

      <div class="row col-4">
        <label class="label">Color</label>
        <input class="input" name="color" placeholder="Rojo / Negro…">
      </div>
      <div class="row col-4">
        <label class="label">Combustible</label>
        <select class="select" name="combustible">
          <option value="">—</option><option>Gasolina</option><option>Diésel</option><option>GLP</option><option>GNV</option><option>Eléctrico</option>
        </select>
      </div>
      <div class="row col-4">
        <label class="label">Transmisión</label>
        <select class="select" name="transmision">
          <option value="">—</option><option>Mecánica</option><option>Automática</option><option>CVT</option>
        </select>
      </div>

      <div class="row col-4">
        <label class="label">Placa</label>
        <input class="input" name="placa" placeholder="ABC-123">
      </div>
      <div class="row col-4">
        <label class="label">N. Motor</label>
        <input class="input" name="nMotor" placeholder="V-9879">
      </div>
      <div class="row col-4">
        <label class="label">VIN</label>
        <input class="input" name="vin" placeholder="17 caracteres">
      </div>

      <div class="col-12 subtle">* Vista frontal (mock). Conecta los <code>name=""</code> a tu Servlet cuando tengas backend.</div>

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">Guardar</button>
        <a class="btn btn-outline" href="vehiculos.jsp">Cancelar</a>
      </div>
    </form>
  </section>
</main>

<script>
// --- Modo create/edit/view sencillo ---
const params = new URLSearchParams(location.search);
const action = params.get('action') || 'create';
const id = params.get('id');

const mockById = {
  1:{cliente:'Tyler Joseph', marca:'Kia', modelo:'Rio', tipo:'Sedán', anio:2021, color:'Rojo', combustible:'Gasolina', transmision:'Automática', placa:'C7L-394', nMotor:'V-9879', vin:'KNADH123456789012'},
  2:{cliente:'Luis Cáceres', marca:'Hyundai', modelo:'Elantra', tipo:'Sedán', anio:2018, color:'Plata', combustible:'Gasolina', transmision:'Mecánica', placa:'BDP-213', nMotor:'X-1223', vin:'KMHAB123456789012'}
};

const form = document.getElementById('formVehiculo');
const title = document.getElementById('title');

if(action==='edit' || action==='view'){
  const data = mockById[id];
  if(data){
    for(const k in data){
      const input = form.querySelector(`[name="${k}"]`);
      if(input) input.value = data[k];
    }
  }
  title.textContent = action==='view' ? 'Ficha del vehículo' : 'Editar vehículo';
  if(action==='view'){ [...form.elements].forEach(el=>el.disabled=true); }
}

form.addEventListener('submit', (e)=>{
  e.preventDefault();
  alert('Vehículo guardado (demo). Conecta al Servlet para persistir.');
  location.href='vehiculos.jsp';
});
</script>
</body>
</html>
