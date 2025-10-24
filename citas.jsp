<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
  // Autorización básica (ajústala a tu proyecto)
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
  <title>AZ Mecánica | Citas</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/estiloM.css?v=<%=System.currentTimeMillis()%>">
</head>
<body>

  <!-- NAV superior (respeta tu look) -->
<header class="topbar">
  <div class="container topbar__row">
    <div class="brand">
      <img src="${pageContext.request.contextPath}/imgs/logo-az.png" alt="AZ" class="logo">
      <span class="brand__label">Clientes</span>
    </div>
    <a class="btn btn-outline" href="login.jsp">Cerrar sesión</a>
  </div>
</header>
  
    <nav class="tabs">
          <a href="index.jsp">Inicio</a>
          <a>Registro de Pagos</a>
          <a>Productos</a>
          <a>Inventario</a>
          <a class="active">Citas</a>
          <a href="servicios.jsp">Servicios</a>
          <a href="clientes.jsp">Clientes</a>
          <a href="vehiculos.jsp">Vehículos</a>
        </nav>
  
  <!-- CONTENIDO -->
  <main class="container">
    <!-- Encabezado del calendario: botones Mes/Semana/Día + leyenda + Nueva cita -->
    <div class="calendar-head row between center">
      <div class="group">
        <button class="btn chip">Mes</button>
        <button class="btn chip">Semana</button>
        <button class="btn chip">Día</button>
        <span class="legend"><i class="dot dot-green"></i> Confirmada</span>
        <span class="legend"><i class="dot dot-yellow"></i> Pendiente</span>
        <span class="legend"><i class="dot dot-gray"></i> Cancelada</span>
      </div>
      <div class="group">
        <button id="btn-nueva" class="btn btn-primary btn-round">+ Nueva cita</button>
      </div>
    </div>

    <div class="grid-calendar">
      <!-- CALENDARIO (izquierda) -->
      <section class="calendar-box">
        <header class="row between center">
          <div class="month-nav">
            <a class="link" href="CitaServlet?action=calendar&move=prev">‹</a>
            <strong>${requestScope.mesNombre} ${requestScope.anio}</strong>
            <a class="link" href="CitaServlet?action=calendar&move=next">›</a>
          </div>
          <div class="right">
            <select onchange="location.href='CitaServlet?action=calendar&dom='+this.value">
              <option ${param.dom=='lun'?'selected':''} value="lun">Dom lun</option>
              <option ${param.dom=='dom'?'selected':''} value="dom">Dom dom</option>
            </select>
          </div>
        </header>

        <table class="table flat calendar">
          <thead>
            <tr>
              <th>Lun</th><th>Mar</th><th>Mié</th><th>Jue</th>
              <th>Vie</th><th>Sáb</th><th>Dom</th>
            </tr>
          </thead>
          <tbody>
            <!-- Estructura esperada del backend:
                 requestScope.semanas -> List<Semana>
                 Semana.dias -> List<Dia>
                 Dia: numero, fechaISO (yyyy-MM-dd), otroMes(boolean), eventos(List<Evento>)
                 Evento: id, horaTxt, cliente, estado(PENDIENTE|CONFIRMADA|CANCELADA), servicio
            -->
            <c:forEach var="sem" items="${requestScope.semanas}">
              <tr>
                <c:forEach var="dia" items="${sem.dias}">
                  <td class="${dia.otroMes?'is-other':''}">
                    <div class="cell-head">
                      <span class="day-num">${dia.numero}</span>
                    </div>
                    <div class="cell-body">
                      <c:forEach var="ev" items="${dia.eventos}">
                        <div class="event"
                             data-id="${ev.id}"
                             data-cliente="${ev.cliente}"
                             data-fecha="${dia.fechaISO}"
                             data-hora="${ev.horaTxt}"
                             data-servicio="${ev.servicio}"
                             data-estado="${ev.estado}">
                          <span class="event-badge ${ev.estado}">
                            ${ev.horaTxt}
                          </span>
                          <small class="event-text">${ev.cliente}</small>
                        </div>
                      </c:forEach>
                    </div>
                  </td>
                </c:forEach>
              </tr>
            </c:forEach>

            <c:if test="${empty requestScope.semanas}">
              <!-- Fallback simple si aún no preparas el backend del calendario -->
              <tr><td colspan="7" class="center muted">Sin calendario generado</td></tr>
            </c:if>
          </tbody>
        </table>
      </section>

      <!-- PANEL LATERAL (derecha) -->
      <aside id="sidepanel" class="sidepanel">
        <!-- Modo: NUEVA CITA (primera imagen) -->
        <div id="panel-new" class="panel-card hidden">
          <div class="panel-header row between center">
            <h3>Nueva cita</h3>
            <button class="icon-btn" data-close>✖</button>
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

            <div class="grid2 gap">
              <div class="field">
                <label>Fecha</label>
                <input type="date" name="fecha" id="fechaNew" required>
              </div>
              <div class="field">
                <label>Hora</label>
                <input type="time" name="hora" required>
              </div>
            </div>

            <div class="field">
              <label>Tipo</label>
              <select name="tipo" required>
                <option value="">Seleccione</option>
                <option>Mantenimiento</option>
                <option>Diagnóstico</option>
                <option>Correctivo</option>
                <option>Preventivo</option>
              </select>
            </div>

            <div class="field">
              <label>Empleado</label>
              <select name="idEmpleado">
                <option value="">Sin asignar</option>
                <c:forEach var="emp" items="${requestScope.empleados}">
                  <option value="${emp.id}">${emp.nombres}</option>
                </c:forEach>
              </select>
            </div>

            <div class="field">
              <label>Notas</label>
              <textarea name="notas" rows="3" placeholder="Detalle adicional..."></textarea>
            </div>

            <footer class="row end gap">
              <button type="button" class="btn" data-close>Cancelar</button>
              <button class="btn btn-primary">Guardar</button>
            </footer>
          </form>
        </div>

        <!-- Modo: DETALLE / CANCELACIÓN (segunda imagen) -->
        <div id="panel-detail" class="panel-card hidden">
          <div class="panel-header"><h3>INFORMACIÓN DE LA CITA</h3></div>

          <form id="form-cancel" method="post" action="CitaServlet">
            <input type="hidden" name="action" value="cancel"/>
            <input type="hidden" name="id" id="det-id"/>

            <div class="field readonly">
              <label>Cliente</label>
              <input type="text" id="det-cliente" readonly>
            </div>

            <div class="grid2 gap">
              <div class="field readonly">
                <label>Fecha</label>
                <input type="text" id="det-fecha" readonly>
              </div>
              <div class="field readonly">
                <label>Hora</label>
                <input type="text" id="det-hora" readonly>
              </div>
            </div>

            <div class="field readonly">
              <label>Servicio</label>
              <input type="text" id="det-servicio" readonly>
            </div>

            <div class="row between gap">
              <button type="submit" class="btn btn-danger-outline">Cancelar cita</button>
              <a id="det-editar" class="btn btn-primary" href="#">Editar</a>
            </div>
          </form>
        </div>
      </aside>
    </div>
  </main>

  <!-- JS mínimo para interacción -->
  <script>
    const qs = s => document.querySelector(s);
    const qsa = s => Array.from(document.querySelectorAll(s));
    const show = el => el.classList.remove('hidden');
    const hide = el => el.classList.add('hidden');

    const panel = qs('#sidepanel');
    const pNew  = qs('#panel-new');
    const pDet  = qs('#panel-detail');

    // Abrir panel "Nueva cita"
    qs('#btn-nueva').addEventListener('click', () => {
      hide(pDet); show(pNew);
      panel.classList.add('open');
    });

    // Cerrar panel
    qsa('[data-close]').forEach(b => b.addEventListener('click', () => {
      hide(pNew); hide(pDet); panel.classList.remove('open');
    }));

    // Click sobre un evento del calendario → abre panel de detalle/cancelación
    document.addEventListener('click', (e) => {
      const ev = e.target.closest('.event'); if (!ev) return;

      // set datos
      qs('#det-id').value      = ev.dataset.id;
      qs('#det-cliente').value = ev.dataset.cliente || '';
      qs('#det-fecha').value   = ev.dataset.fecha   || '';
      qs('#det-hora').value    = ev.dataset.hora    || '';
      qs('#det-servicio').value= ev.dataset.servicio|| '';
      qs('#det-editar').href   = 'cita-form.jsp?id=' + encodeURIComponent(ev.dataset.id);

      hide(pNew); show(pDet);
      panel.classList.add('open');
    });

    // Si el backend te envía un parámetro ?mode=new o ?mode=detail&id=...
    <% String mode = request.getParameter("mode"); %>
    <% if ("new".equals(mode)) { %>
      document.addEventListener('DOMContentLoaded', () => { 
        hide(qs('#panel-detail')); show(qs('#panel-new')); qs('#sidepanel').classList.add('open');
        // Si te pasaron fecha preseleccionada (?date=yyyy-MM-dd)
        const pre = '<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>';
        if (pre) qs('#fechaNew').value = pre;
      });
    <% } else if ("detail".equals(mode)) { %>
      document.addEventListener('DOMContentLoaded', () => { 
        hide(qs('#panel-new')); show(qs('#panel-detail')); qs('#sidepanel').classList.add('open');
        // Precargar (si te llega en requestScope.detalle)
      });
    <% } %>
  </script>

  <!-- 
    NOTAS DE BACKEND (ajusta a tu proyecto):
    - CitaServlet?action=calendar  debe setear:
        request.setAttribute("mesNombre", "Octubre"); 
        request.setAttribute("anio", 2025);
        request.setAttribute("semanas", semanas); // ver estructura en el tbody
        request.setAttribute("clientes", clientes); // para el panel "Nueva cita"
        request.setAttribute("empleados", empleados);
    - POST CitaServlet?action=create   → crea cita y redirige a citas.jsp
    - POST CitaServlet?action=cancel   → marca estado CANCELADA y redirige
    - GET  cita-form.jsp?id=:id        → edición avanzada (si ya la tienes)
  -->
</body>
</html>
