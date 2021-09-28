// JavaScript Document

function goTo( url ) {
	window.location.href = url;
}

function Change_roofBar( tableCellRef, hoverFlag ) {
	if ( hoverFlag ) {
		tableCellRef.style.backgroundImage = 'url("../imagenes/back_gris_seleccionado.gif")';
		if ( document.getElementsByTagName ) {
			tableCellRef.getElementsByTagName( 'a' )[0].style.color = '#00008B';
		}
	} else {
		tableCellRef.style.backgroundImage = 'url("../imagenes/back_gris.gif")';
		if ( document.getElementsByTagName ) {
			tableCellRef.getElementsByTagName( 'a' )[0].style.color = '#333';
		}
	}
}

function roofBar_Click( tableCellRef, url ) {
	Change_roofBar( tableCellRef, 0 );
	goTo( url );
}


