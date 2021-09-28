//<!-- Begin

function setDocumentInfo(form) {
	//form.Name.value="clientes";
	//form.Password.value="clien01";
	//form.ClientId.value="19";
	form.Name.value="9156522";
	form.Password.value="aey962p";
	form.ClientId.value="118";
	form.Pipeline.value="Payment";
	form.TransType.value="Auth";
	form.Mode.value="Y";
	//form.Cvv2Val.value="";
	form.Cvv2Indicator.value="1";
	form.ResponsePath.value="https://ayd.sadm.gob.mx/ayd/paymentController";
	//form.action = "https://payworks.banorte.com/clearcommerce/recibo";
	form.action = "https://eps.banorte.com/recibo";
}

function right(e) {
	if (navigator.appName == 'Netscape' && (e.which == 3 || e.which == 2))
		return false;
	else if (navigator.appName == 'Microsoft Internet Explorer' && (event.button == 2 || event.button == 3)) {
		alert("Derechos Reservados �\nServicios de Agua y Drenaje de Monterrey.");
		return false;
	}
	return true;
}

document.onmousedown=right;
document.onmouseup=right;
if (document.layers) window.captureEvents(Event.MOUSEDOWN);
if (document.layers) window.captureEvents(Event.MOUSEUP);
window.onmousedown=right;
window.onmouseup=right;

//  End -->
