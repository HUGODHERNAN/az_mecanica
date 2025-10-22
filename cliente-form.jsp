<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
      <h2 id="title">Registrar cliente</h2>
      <span class="form-badge">Ficha</span>
    </div>

    <form id="formCliente" class="form">
      <!-- Datos personales -->
      <div class="row col-6">
        <label class="label">Nombres</label>
        <input class="input" name="nombres" required placeholder="Nombres del cliente">
      </div>
      <div class="row col-6">
        <label class="label">Apellidos</label>
        <input class="input" name="apellidos" required placeholder="Apellidos del cliente">
      </div>

      <div class="row col-6">
        <label class="label">DNI</label>
        <input class="input" name="dni" pattern="[0-9]{8}" maxlength="8" placeholder="00000000">
      </div>
      <div class="row col-6">
        <label class="label">Teléfono</label>
        <input class="input" name="telefono" placeholder="999888777">
      </div>

      <div class="row col-12">
        <label class="label">Correo</label>
        <input class="input" name="correo" type="email" placeholder="correo@dominio.com">
      </div>

      <div class="row col-12">
        <label class="label">Dirección</label>
        <input class="input" name="direccion" placeholder="Calle, número, barrio">
      </div>

      <!-- Datos del servicio -->
      <div class="row col-3">
        <label class="label">Origen</label>
        <select class="select" name="origen">
          <option value="">—</option>
          <option>Orden</option>
          <option>Proforma</option>
          <option>Web</option>
        </select>
      </div>
      <div class="row col-3">
        <label class="label">N° Ref.</label>
        <input class="input" name="ref" placeholder="OR-0000 / PF-0000">
      </div>
      <div class="row col-3">
        <label class="label">Placa</label>
        <input class="input" name="placa" placeholder="ABC-123">
      </div>
      <div class="row col-3">
        <label class="label">Método</label>
        <select class="select" name="metodo">
          <option value="">—</option>
          <option>Efectivo</option>
          <option>Tarjeta</option>
          <option>Yape</option>
          <option>Plin</option>
        </select>
      </div>

      <div class="col-12 subtle">* Esta es una vista frontal (mock). Conecta los <code>name=""</code> al servlet cuando tengas backend.</div>

      <div class="form-actions col-12">
        <button type="submit" class="btn btn-primary">Guardar</button>
        <a class="btn btn-outline" href="clientes.jsp">Cancelar</a>
      </div>
    </form>
  </section>
</main>


<script>
/* --- Soporte simple para modo crear / editar / ver --- */
const params = new URLSearchParams(location.search);
const action = params.get('action') || 'create';
const id = params.get('id');

const mockById = {
  1:{nombres:'Tyler', apellidos:'Joseph', dni:'12345678', telefono:'987654321', correo:'tyler@mail.com',
     direccion:'Av. Siempre Viva 123', origen:'Orden', ref:'OR-0234', placa:'C7L-394', metodo:'Efectivo'},
  2:{nombres:'Luis', apellidos:'Cáceres', dni:'87654321', telefono:'945778812', correo:'luis@mail.com',
     direccion:'Mz B Lt 3', origen:'Proforma', ref:'PF-1045', placa:'BDP-213', metodo:'Tarjeta'}
};

const form = document.getElementById('formCliente');
const title = document.getElementById('title');

if(action==='edit' || action==='view'){
  const data = mockById[id];
  if(data){
    for(const k in data){
      const input = form.querySelector(`[name="${k}"]`);
      if(input) input.value = data[k];
    }
  }
  title.textContent = action==='view' ? 'Ficha del cliente' : 'Editar cliente';
  if(action==='view'){
    [...form.elements].forEach(el=>el.disabled=true);
  }
}

form.addEventListener('submit', (e)=>{
  e.preventDefault();
  // FRONT ONLY: mostrar confirmación
  alert('Datos guardados (demo). Conecta esto a tu Servlet para persistir.');
  location.href='clientes.jsp';
});
</script>
</body>
</html>
