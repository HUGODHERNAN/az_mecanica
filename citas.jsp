<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  String rolGuard = (String) session.getAttribute("rol");
  if (rolGuard == null || !"ADMIN".equals(rolGuard)) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
  String eventosJson = (String) request.getAttribute("eventosJson");
  if (eventosJson == null) eventosJson = "[]";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>AZ Mecánica | Citas</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body>

    <header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Citas</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>
      
  <nav class="tabs">
  <a href="index.jsp">Inicio</a>
  <a class="active">Citas</a>
  <a href="clientes.jsp">Clientes</a>
  <a href="inventario.jsp">Inventario</a>
  <a>Productos</a>
  <a>Registro de Pagos</a>
  <a href="servicios.jsp">Servicios</a>
  <a href="vehiculos.jsp">Vehículos</a>
  </nav>

<main class="container">
  <div class="az-calbar">
    <div class="az-calbar__left">
      <button class="az-chip az-chip--seg" data-az-view="month">Me</button>
      <button class="az-chip az-chip--seg" data-az-view="week">Se</button>
      <button class="az-chip az-chip--seg" data-az-view="day">Di</button>
      <span class="legend"><i class="dot dot-green"></i> Confirmada</span>
      <span class="legend"><i class="dot dot-yellow"></i> Pendiente</span>
      <span class="legend"><i class="dot dot-gray"></i> Cancelada</span>
    </div>
    <button id="az-ct-btn-new" class="btn btn-primary btn-round">+ Nueva cita</button>
  </div>

  <div class="az-gridcal">
    <section class="calendar-box">
      <header class="row between center az-calhdr">
        <div class="month-nav">
          <button id="az-prev" class="btn">‹</button>
          <strong id="az-title"></strong>
          <button id="az-next" class="btn">›</button>
        </div>
      </header>
      <div id="az-cal-container"></div>
    </section>

    <aside id="az-side" class="sidepanel">
      <div id="az-pane-new" class="panel-card az-hide">
        <div class="panel-header row between center">
          <h3>Nueva cita</h3>
          <button class="icon-btn" data-az-close>✖</button>
        </div>
        <form method="post" action="CitaServlet">
          <input type="hidden" name="action" value="create"/>
          <div class="field">
            <label>Cliente</label>
            <select name="idCliente" id="idCliente" required>
              <option value="">Seleccione</option>
              <c:forEach var="cli" items="${requestScope.clientes}">
                <option value="${cli.id}">${cli.nombre} ${cli.apellido}</option>
              </c:forEach>
            </select>
          </div>
          <div class="az-grid2">
            <div class="field"><label>Fecha</label><input id="az-new-date" type="date" name="fecha" required></div>
            <div class="field"><label>Hora</label><input type="time" name="hora" required></div>
          </div>
          <div class="field">
            <label>Tipo</label>
            <select name="tipo" required>
              <option value="">Seleccione</option>
              <option>Mantenimiento</option><option>Diagnóstico</option>
              <option>Correctivo</option><option>Preventivo</option>
            </select>
          </div>
          <div class="field">
            <label>Empleado</label>
            <select name="idEmpleado">
              <option value="">Sin asignar</option>
              <c:forEach var="e" items="${requestScope.empleados}">
                <option value="${e.id}">${e.nombres}</option>
              </c:forEach>
            </select>
          </div>
          <div class="field"><label>Notas</label><textarea name="notas" rows="3"></textarea></div>
          <footer class="row end gap">
            <button type="button" class="btn" data-az-close>Cancelar</button>
            <button class="btn btn-primary">Guardar</button>
          </footer>
        </form>
      </div>

      <div id="az-pane-det" class="panel-card az-hide">
        <div class="panel-header"><h3>INFORMACIÓN DE LA CITA</h3></div>
        <form method="post" action="CitaServlet">
          <input type="hidden" name="action" value="cancel"/>
          <input type="hidden" name="id" id="az-det-id"/>
          <div class="field readonly"><label>Cliente</label><input id="az-det-cli" readonly></div>
          <div class="az-grid2">
            <div class="field readonly"><label>Fecha</label><input id="az-det-fe" readonly></div>
            <div class="field readonly"><label>Hora</label><input id="az-det-ho" readonly></div>
          </div>
          <div class="field readonly"><label>Servicio</label><input id="az-det-ser" readonly></div>
          <div class="row between gap">
            <button class="btn btn-danger-outline" type="submit">Cancelar cita</button>
            <a id="az-det-edit" class="btn btn-primary" href="#">Editar</a>
          </div>
        </form>
      </div>
    </aside>
  </div>
</main>

<!-- JSON de eventos desde backend -->
<script type="application/json" id="events-data"><%=eventosJson%></script>

<script>
  // ===== Helpers
  var $  = function(s){ return document.querySelector(s); };
  var $$ = function(s){ return Array.prototype.slice.call(document.querySelectorAll(s)); };
  var show = function(el){ el.classList.remove('az-hide'); };
  var hide = function(el){ el.classList.add('az-hide'); };

  // Lee JSON del backend
  var EVENTS = JSON.parse(document.getElementById('events-data').textContent || '[]');

  // Si no hay eventos del backend, cargar ejemplos 27 y 31/oct/2025
  if (!EVENTS || EVENTS.length === 0) {
    EVENTS = [
      {
        id: 101,
        fecha: "2025-10-27",           // Lunes
        horaInicio: "09:00",
        horaFin: "10:00",
        cliente: "Juan Pérez",
        servicio: "Mantenimiento",
        estado: "CONFIRMADA"
      },
      {
        id: 102,
        fecha: "2025-10-31",           // Viernes
        horaInicio: "15:00",
        horaFin: "16:00",
        cliente: "María López",
        servicio: "Diagnóstico",
        estado: "PENDIENTE"
      }
    ];
  }

  // normaliza
  EVENTS.forEach(function(e){
    if (!e.horaInicio && e.hora) e.horaInicio = e.hora;
    if (!e.horaFin && e.duracionMin){
      var d = new Date('2000-01-01T' + e.horaInicio + ':00');
      d.setMinutes(d.getMinutes() + Number(e.duracionMin || 60));
      e.horaFin = d.toTimeString().slice(0,5);
    }
    if (!e.horaFin) e.horaFin = e.horaInicio;
  });

  // Vista inicial: si hay eventos, céntrate en el primero (para verlos de frente)
  var view = 'week';
  var cursor = (EVENTS && EVENTS.length>0)
      ? new Date(EVENTS[0].fecha + 'T00:00:00')
      : new Date();
  cursor.setHours(0,0,0,0);

  var fmtMonthTitle = function(d){ return d.toLocaleDateString('es-PE', {month:'long', year:'numeric'}); };
  var ymd = function(d){ return d.toISOString().slice(0,10); };

  // ===== MES
  function renderMonth(){
    $('#az-title').textContent = fmtMonthTitle(cursor);
    var first = new Date(cursor.getFullYear(), cursor.getMonth(), 1);
    var start = new Date(first);
    var wd = (first.getDay()+6)%7;
    start.setDate(1 - wd);

    var grid = document.createElement('table');
    grid.className = 'table flat calendar';
    grid.innerHTML =
      '<thead><tr><th>Lun</th><th>Mar</th><th>Mié</th><th>Jue</th><th>Vie</th><th>Sáb</th><th>Dom</th></tr></thead>' +
      '<tbody id="az-month-body"></tbody>';

    var body = grid.querySelector('#az-month-body');

    for(var w=0; w<6; w++){
      var tr = document.createElement('tr');
      for(var d=0; d<7; d++){
        var date = new Date(start); date.setDate(start.getDate()+w*7+d);
        var inMonth = (date.getMonth() === cursor.getMonth());
        var td = document.createElement('td');
        td.className = inMonth ? '' : 'is-other';
        td.innerHTML = '<div class="cell-head"><span class="day-num">'+date.getDate()+
                       '</span></div><div class="cell-body"></div>';
        var dayStr = ymd(date);
        EVENTS.filter(function(e){return e.fecha===dayStr;}).forEach(function(ev){
          var a = document.createElement('div');
          a.className = 'event';
          a.dataset.id = ev.id;
          a.dataset.cliente = ev.cliente;
          a.dataset.fecha = ev.fecha;
          a.dataset.hora = ev.horaInicio;
          a.dataset.servicio = ev.servicio;
          a.dataset.estado = ev.estado;
          a.innerHTML = '<span class="event-badge '+ev.estado+'">'+ev.horaInicio+
                        '</span><small class="event-text">'+ev.cliente+'</small>';
          td.querySelector('.cell-body').appendChild(a);
        });
        tr.appendChild(td);
      }
      body.appendChild(tr);
    }
    $('#az-cal-container').innerHTML = '';
    $('#az-cal-container').appendChild(grid);
  }

  // ===== SEMANA / DÍA
  var HOURS = Array.from({length:11},function(_,i){ return 8+i; }); // 08:00..18:00

  function renderWeek(){
    var monday = new Date(cursor);
    monday.setDate(cursor.getDate() - ((cursor.getDay()+6)%7));

    var end = new Date(monday); end.setDate(monday.getDate()+6);
    var title = monday.toLocaleDateString('es-PE',{day:'2-digit',month:'long'}) +
                ' - ' +
                end.toLocaleDateString('es-PE',{day:'2-digit',month:'long',year:'numeric'});
    $('#az-title').textContent = 'Semana • ' + title;

    var wrap = document.createElement('div');
    wrap.className = 'az-weekwrap';

    // header
    var head = document.createElement('div');
    head.className = 'az-weekhead';

    var daysHtml = '';
    for (var i=0;i<7;i++){
      var d = new Date(monday); d.setDate(monday.getDate()+i);
      var name = ['Lun','Mar','Mié','Jue','Vie','Sáb','Dom'][i];
      daysHtml += '<div class="az-col-day">'+name+'<br><small>'+d.getDate()+'</small></div>';
    }
    head.innerHTML = '<div class="az-col-time">Hora</div>' + daysHtml;
    wrap.appendChild(head);

    // body grid
    var body = document.createElement('div');
    body.className = 'az-weekbody';

    HOURS.forEach(function(h){
      var row = document.createElement('div');
      row.className = 'az-row';
      var slots = '';
      for (var j=0;j<7;j++) slots += '<div class="az-slot"></div>';
      row.innerHTML = '<div class="az-col-time">'+String(h).padStart(2,'0')+':00</div>' + slots;
      body.appendChild(row);
    });

    // eventos
    EVENTS.forEach(function(ev){
      var d = new Date(ev.fecha+'T00:00:00');
      var idx = ((d.getDay()+6)%7);
      var evDate = new Date(monday); evDate.setDate(monday.getDate()+idx);
      if (evDate.getMonth()!==d.getMonth() || evDate.getDate()!==d.getDate()) return;

      var sh = parseInt(ev.horaInicio.split(':')[0],10);
      var rowIdx = sh - HOURS[0];
      if (rowIdx < 0 || rowIdx >= HOURS.length) return;

      var cell = body.children[rowIdx].querySelectorAll('.az-slot')[idx];
      var block = document.createElement('div');
      block.className = 'az-evt ' + ev.estado;
      block.dataset.id = ev.id;
      block.dataset.cliente = ev.cliente;
      block.dataset.fecha = ev.fecha;
      block.dataset.hora  = ev.horaInicio;
      block.dataset.servicio = ev.servicio;
      block.dataset.estado = ev.estado;
      block.innerHTML = '<strong>'+ev.horaInicio+'</strong><span>'+ev.cliente+'</span>';
      cell.appendChild(block);
    });

    $('#az-cal-container').innerHTML = '';
    wrap.appendChild(body);
    $('#az-cal-container').appendChild(wrap);
  }

  function renderDay(){
    var title = cursor.toLocaleDateString('es-PE', {weekday:'long', day:'2-digit', month:'long', year:'numeric'});
    $('#az-title').textContent = 'Día • ' + title;

    var wrap = document.createElement('div');
    wrap.className = 'az-daywrap';

    var head = document.createElement('div');
    head.className = 'az-dayhead';
    head.innerHTML = '<div class="az-col-time">Hora</div><div class="az-col-day">Agenda</div>';
    wrap.appendChild(head);

    var body = document.createElement('div');
    body.className = 'az-daybody';

    HOURS.forEach(function(h){
      var row = document.createElement('div');
      row.className = 'az-row';
      row.innerHTML = '<div class="az-col-time">'+String(h).padStart(2,'0')+':00</div><div class="az-slot"></div>';
      body.appendChild(row);
    });

    var todayStr = ymd(cursor);
    EVENTS.filter(function(e){return e.fecha===todayStr;}).forEach(function(ev){
      var sh = parseInt(ev.horaInicio.split(':')[0],10);
      var idx = sh - HOURS[0];
      if (idx<0 || idx>=HOURS.length) return;
      var cell = body.children[idx].querySelector('.az-slot');
      var block = document.createElement('div');
      block.className = 'az-evt ' + ev.estado;
      block.dataset.id = ev.id;
      block.dataset.cliente = ev.cliente;
      block.dataset.fecha = ev.fecha;
      block.dataset.hora  = ev.horaInicio;
      block.dataset.servicio = ev.servicio;
      block.dataset.estado = ev.estado;
      block.innerHTML = '<strong>'+ev.horaInicio+'</strong><span>'+ev.cliente+'</span>';
      cell.appendChild(block);
    });

    $('#az-cal-container').innerHTML = '';
    wrap.appendChild(body);
    $('#az-cal-container').appendChild(wrap);
  }

  function paint(){ if(view==='month') renderMonth(); else if(view==='week') renderWeek(); else renderDay(); }

  // ===== NAV & PANEL
  $('#az-prev').addEventListener('click', function(){
    if(view==='month') cursor.setMonth(cursor.getMonth()-1);
    else cursor.setDate(cursor.getDate() - (view==='week'?7:1));
    paint();
  });
  $('#az-next').addEventListener('click', function(){
    if(view==='month') cursor.setMonth(cursor.getMonth()+1);
    else cursor.setDate(cursor.getDate() + (view==='week'?7:1));
    paint();
  });

  $$('[data-az-view]').forEach(function(b){
    b.addEventListener('click', function(){ view = b.getAttribute('data-az-view'); paint(); });
  });

  $('#az-ct-btn-new').addEventListener('click', function(){
    hide($('#az-pane-det')); show($('#az-pane-new')); $('#az-side').classList.add('open');
  });

  $$('[data-az-close]').forEach(function(b){
    b.addEventListener('click', function(){
      hide($('#az-pane-new')); hide($('#az-pane-det')); $('#az-side').classList.remove('open');
    });
  });

  // Al hacer clic en un evento, abrir panel con datos y habilitar Editar/Cancelar
  document.addEventListener('click', function(e){
    var ev = e.target.closest('.event, .az-evt'); if(!ev) return;
    $('#az-det-id').value = ev.dataset.id || '';
    $('#az-det-cli').value = ev.dataset.cliente || '';
    $('#az-det-fe').value  = ev.dataset.fecha   || '';
    $('#az-det-ho').value  = ev.dataset.hora    || '';
    $('#az-det-ser').value = ev.dataset.servicio|| '';
    $('#az-det-edit').href = 'cita-form.jsp?id=' + encodeURIComponent(ev.dataset.id || '');
    hide($('#az-pane-new')); show($('#az-pane-det')); $('#az-side').classList.add('open');
  });

  document.addEventListener('DOMContentLoaded', paint);
</script>
</body>
</html>
