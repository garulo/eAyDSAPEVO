/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function addServices() {
	document.objectInfo.command.value = "desplegar servicio";
	document.objectInfo.action = "userController";
	document.objectInfo.submit();
}
function doLogOut() {
        document.objectInfo.action = "userController";
	document.objectInfo.command.value = 'salir';
	document.objectInfo.submit();
}
function returnToServices() {
        //alert("returnToServices()-"+document.objectInfo);
	document.objectInfo.command.value = 'servicios';
	document.objectInfo.action = "paymentController";
	document.objectInfo.submit();
}
function changeAction(actionName) {
        document.objectInfo.action = "userController";
	document.objectInfo.command.value = actionName;
	document.objectInfo.submit();
}
function payServices() {

    if (hasServicesSelected()) {
            document.objectInfo.command.value = "ver pago";
            document.objectInfo.submit();
    }

}
function hasServicesSelected() {
	if (document.objectInfo.Total.value !== "0.00") {
		return true;
	} else {
		swal("No ha seleccionado servicios a pagar.");
		return false;
	}
}
function NewWindow(mypage, myname, w, h, scroll) {
	var winl = (screen.width - w) / 2;
	var wint = (screen.height - h) / 2;
	winprops = 'height='+h+',width='+w+',top='+wint+',left='+winl+',scrollbars='+scroll+',resizable'
	win = window.open(mypage, myname, winprops)
	if (parseInt(navigator.appVersion) >= 4) {
		win.window.focus();
	}
        
        
}
function checkNumber(creditNumber) {
	var intValue = parseInt(creditNumber.value);
	if (isNaN(intValue)) {
		alert("No es un número de tarjeta válido.");
		creditNumber.value = "";
		creditNumber.focus();
		return false;
	}
	else {
		if (creditNumber.value.length == 16) {
			return true;
		}
		else {
			alert("Por favor verifique la cantidad de dígitos.");
			creditNumber.focus();
			return false;
		}
	}
}
function hasServicesSelected() {
	if (document.objectInfo.Total.value != "0.00") {
		return true;
	} else {
		alert("No ha seleccionado servicios a pagar.");
		return false;
	}
}
//Para consultar Recibos...
function recibo(actionName,Nis) {
	document.objectInfo.command.value = actionName;
	document.objectInfo.nisRad.value = Nis;
	document.objectInfo.action = "userController";
	window.open ("userController?command=Ultimo Recibo&nisRad="+Nis+"", 'New', 'height=400,width=640,status,scrollbars,top=10px,left=10px');
}

function bajarFacturas(actionName,Nis) {
	document.objectInfo.command.value = actionName;
	document.objectInfo.nisRad.value = Nis;
	document.objectInfo.action = "userController";
	window.open ("userController?command=getFacturasFiles&nisRad="+Nis+"", 'New', 'height=400,width=640,status,scrollbars,top=10px,left=10px');
}
function doDelteServie(param) {
        if(confirm('¿Está seguro que desea eliminar el servicio?')){
            document.objectInfo.input_DS.value = param;
            document.objectInfo.command.value = "eliminar servicio";
            document.objectInfo.action = "userController";
            document.objectInfo.submit();
        } else {
            return false;
        }
}
function cancelPayment() {
	document.objectInfo.command.value = "cancelar pago";
	document.objectInfo.submit();
}
