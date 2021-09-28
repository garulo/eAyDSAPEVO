// script generated by Xtreeme SiteXpert
// sitemap and search engine creator
// http://www.xtreeme.com/sitexpert
// Copyright(C) 2001-2002 Xtreeme GmbH

if (!document.loadHandlers)
{
	document.loadHandlers=new Array();
	document.loadHandlers[0]='initializeMenu';
	document.lastLoadHandler=0;
}
else
{
	document.lastLoadHandler++;
	document.loadHandlers[document.lastLoadHandler]='initializeMenu';
}
window.onload=initializeAll;
function errorTrap(){return true;}
window.onerror=errorTrap;

function createMenuItem(nmenu,popup,id,itemLink,itemText,popupArray,levelAttribs,bLast,popupHeight,parent)
{
	var itemType=0;
	var itemWnd=createElementEx(nmenu.popupFrame.document,popup,"span","id",id,null,null,"width",nmenu.popupWidth-2*nmenu.bord,null,null);
	itemWnd.innerHTML=itemText;
	addEvent(itemWnd,"mouseover",onItemOver,false);
	addEvent(itemWnd,"mouseout",onItemOut,false);
	addEvent(itemWnd,"mousedown",onItemClick,false);
	addEvent(itemWnd,"dblclick",onItemClick,false);
	itemWnd.owner=popup;
	with (itemWnd.style)
	{
		if(itemType==2)top=popupHeight-nmenu.scrollHeight;
		else top=popupHeight;
		if(itemLink){cursor=(!IE4||version>=6)?"pointer":"hand";}
		else{cursor="default";}
		color=levelAttribs [3];
		if (!bLast)
		{
			borderBottomColor=nmenu.borderCol;
			borderBottomWidth=nmenu.sep;
			borderBottomStyle="solid";
		}
		if (!itemType)padding=nmenu.vertSpace;
		paddingLeft=nmenu.popupLeftPad+nmenu.vertSpace;
		paddingRight=(nmenu.popupRightPad<nmenu.iconSize?nmenu.iconSize:nmenu.popupRightPad)+nmenu.vertSpace;
		fontSize=levelAttribs[0];
		fontWeight=(levelAttribs[1])?"bold":"normal";
		fontStyle=(levelAttribs[2])?"italic":"normal";
		fontFamily=levelAttribs[6];
	}
	if (popupArray)itemWnd.popupArray=popupArray;
	if(itemLink&&itemLink.indexOf(':/')==-1&&itemLink.indexOf(':\\')==-1) itemWnd.url=unescape(absPath)+itemLink;
	else itemWnd.url=itemLink;
	itemWnd.dispText=itemText;
	if (popupArray)
	{
		var leftImgPos=nmenu.popupWidth-nmenu.bord-nmenu.iconSize-5;
		var topImgPos=itemWnd.offsetHeight/2-nmenu.iconSize/2+popupHeight-2;
		txt="<div style='width:"+nmenu.iconSize+";height:"+nmenu.iconSize+";position:absolute;left:"+leftImgPos+";top:"+topImgPos+"'>";
		txt+="<img src='";
		if(nmenu.imgFolder.indexOf('/')!=0)txt+=unescape(absPath);
		txt+=nmenu.imgFolder+"/sxicona.gif' border=0 width="+nmenu.iconSize+" height="+nmenu.iconSize+" align=right></span>";
		itemWnd.insertAdjacentHTML("BeforeEnd",txt);
	}
	return itemWnd.offsetHeight;
}

function createPopupFromCode(nmenu,arrayName,level)
{
	var popupName=arrayName+"popup";
	var popup=getElementById(nmenu.popupFrame,popupName);
	if (popup)return popup;
	var levelAttribs;
	if (level > nmenu.maxlev) {levelAttribs = eval ("nmenu.lev" + nmenu.maxlev) ;} else {levelAttribs = eval ("nmenu.lev" + level) ;}
	popup=createElementEx(nmenu.popupFrame.document,nmenu.popupFrame.document.body,"DIV","id",popupName,null,null,"position","absolute",null,null);
	popup.level=level;
	popup.highlightColor=levelAttribs[5];
	popup.normalColor=levelAttribs[3];
	popup.highlightBgColor=levelAttribs[7];
	popup.normalBgColor=levelAttribs[4];
	popup.scrVis=false;
	popup.nmenu=nmenu;
	with (popup.style)
	{
		zIndex=maxZ;
		width=nmenu.popupWidth;
		borderColor=nmenu.borderCol;
		backgroundColor=levelAttribs[4];
		borderWidth=nmenu.bord;
		borderStyle="solid";
	}
	addEvent(popup,"mouseout",onPopupOut,false);
	addEvent(popup,"mouseover",onPopupOver,false);

	var popupHeight=0;

	popup.style.backgroundColor=levelAttribs[4];

	var array=eval(arrayName);
	var arrayItem;
	for(arrayItem=0;arrayItem<array.length/3;arrayItem++)
	{
		var popupArray=(array[arrayItem*3+2])?(arrayName+"_"+parseInt(arrayItem+1)):null;
		popupHeight+=createMenuItem(nmenu,popup,null,array[arrayItem*3+1],array[arrayItem*3],popupArray,levelAttribs,(arrayItem == array.length/3-1),popupHeight,popup);
	}
	popup.style.height=popupHeight+nmenu.bord*2;
	popup.maxHeight=popupHeight+nmenu.bord*2;
	var bottomImgHeight=0;
	return popup;
}

function closePopup(nmenu,popupId)
{
	if(popupId.indexOf('_')==-1){var hideWnd=getElementById(nmenu.popupFrame,'HideItem');if(hideWnd)hideWnd.style.display='none';}
	var popup=getElementById(nmenu.popupFrame,popupId);
	if (popup)
	{
		if (popup.expandedWnd) closePopup (nmenu,popup.expandedWnd.id);
		popup.style.display="none";
	}
	if (nmenu.activePopup && nmenu.activePopup.id==popupId) nmenu.activePopup=null;
}

function absToRel(rect,refx,refy)
{
	var retval=new rct(rect.left-refx,rect.top-refy,rect.right-refx,rect.bottom-refy);
	return retval;
}

function openPopup(nmenu,popup,x,y,bDontMove,refWnd)
{
	if(popup.id.indexOf('_')==-1){var hideWnd=getElementById(nmenu.popupFrame,'HideItem');if(hideWnd)hideWnd.style.display='';}
	popup.style.left=x;
	popup.style.top=y;
	popup.style.display="";
	var popupRect=getClientRect(nmenu,popup);
	var browserRect=getBrowserRect(nmenu.popupFrame);
	var bResize=(popup.offsetHeight<popup.maxHeight);
	if (x+nmenu.popupWidth>browserRect.right)
	{
		if(refWnd&&refWnd.id&&refWnd.id.indexOf('top')==-1)popup.style.left=Math.max(0,refWnd.offsetLeft-nmenu.popupWidth+nmenu.levelOffset);
		else popup.style.left=browserRect.right-popup.offsetWidth-5;
	}
}

function isChildOfActivePopup(nmenu,popup)
{
	var wnd=nmenu.activePopup;
	while(wnd)
	{
		if (wnd.id==popup.id)
		{
			return true;
		}
		wnd=wnd.expandedWnd;
	}
	return false;
}

function onPopupOver()
{
	var nmenu=this.nmenu;
	if (nmenu.activePopup && isChildOfActivePopup (nmenu,this)) clearTimeout(nmenu.activePopupTimeout);
}

function onPopupOut()
{
	var nmenu=this.nmenu;
	onPopupOutImpl(nmenu,this);
}

function onPopupOutImpl(nmenu,popup)
{
	if (nmenu.mout && nmenu.activePopup && isChildOfActivePopup (nmenu,popup))
	{
		if (nmenu.activePopupTimeout) clearTimeout (nmenu.activePopupTimeout);
		nmenu.activePopupTimeout=setTimeout("closePopup("+nmenu.name+",'"+nmenu.activePopup.id+"');", nmenu.closeDelay);
	}
}

function rct(left,top,right,bottom)
{
	this.left=left;
	this.top=top;
	this.right=right;
	this.bottom=bottom;
}

function getBrowserRect(doc)
{
	var left=0;
	var top=0;
	var right;
	var bottom;
	if(doc.pageXOffset)left=doc.pageXOffset;
	else if(doc.document.body.scrollLeft)left=doc.document.body.scrollLeft;
	if(doc.pageYOffset)top=doc.pageYOffset;
	else if(doc.document.body.scrollTop)top=doc.document.body.scrollTop;
	if(doc.innerWidth)right=left+doc.innerWidth;
	else if(doc.document.body.clientWidth)right=left+doc.document.body.clientWidth;
	if(doc.innerHeight)bottom=top+doc.innerHeight;
	else if(doc.document.body.clientHeight)bottom=top+doc.document.body.clientHeight;
	var retval=new rct(left,top,right,bottom);
	return retval;	
}

function getClientRect(nmenu,wnd)
{
	var left=mac?document.body.leftMargin:0;
	var top=mac?document.body.topMargin:0;
	var right=0;
	var bottom=0;
	var par=wnd;
	while (par)
	{
		left+=par.offsetLeft;
		top+=par.offsetTop;
		if (par.offsetParent==par || par.offsetParent==nmenu.popupFrame.document.body) break;
		par=par.offsetParent;
	}
	right=left+wnd.offsetWidth;
	bottom=top+wnd.offsetHeight;
	var retval=new rct(left,top,right,bottom);
	return retval;
}

function onItemClick()
{

	var item=this;
	var nmenu=this.owner.nmenu;
	if (item.url)
	{
		var startPos=item.dispText.indexOf('<!--');
		if (startPos!=-1)
		{
			var endPos = item.dispText.indexOf('-->',startPos);
			var trgFrame = item.dispText.substring (startPos+4,endPos);
			if (trgFrame=="_blank") window.open (item.url);
			else if (trgFrame.indexOf('_')==0) parent.location.href=item.url;
			else eval("parent.frames."+trgFrame).location.href=item.url;
		}
		else
		{
			var find=item.url.indexOf("javascript:");
			if (find!=-1)
				eval(item.url.substring(find));
			else
			{
				var mt=item.url.indexOf("mailto:");
				if(mt!=-1)window.top.location=item.url.substring(mt);
				else nmenu.targetFrame.location=item.url;
			}
		}
		if(nmenu.activePopup)closePopup(nmenu,nmenu.activePopup.id);
	}
}

function onItemOver()
{
	var item=this;
	var nmenu=this.owner.nmenu;
	if (item.owner.expandedWnd)
	{
		closePopup(nmenu,item.owner.expandedWnd.id);
	}
	if (item.url&&item.url.indexOf("javascript:")==-1)
		window.status=item.url;
	else
		window.status="";
	item.style.color=item.owner.highlightColor;
	item.style.backgroundColor=item.owner.highlightBgColor;
	var items=getElementsByTagName(item.owner,"SPAN");
	var i=0;
	for (;i<items.length;i++)
	if(item!=items[i]&&(!items[i].id||items[i].id.indexOf("scroll")==-1))
	{
		items[i].style.backgroundColor=item.owner.normalBgColor;
		items[i].style.color=item.owner.normalColor;
	}
	if (item.popupArray)
	{
		var rect=getClientRect(nmenu,item);
		var x=rect.right-nmenu.levelOffset;
		var y=rect.top;
		var popup=createPopupFromCode(nmenu,item.popupArray,item.owner.level+1);
		item.owner.expandedWnd=popup;
		openPopup(nmenu,popup,x,y+2,false,item.owner);
	}
}

function onItemOut()
{
	var item=this;
	var nmenu=this.owner.nmenu;
	item.style.color=item.owner.normalColor;
	item.style.backgroundColor=item.owner.normalBgColor;
}

function createElementEx(ownerDocument,parent,tag,a1,av1,a2,av2,s1,sv1,s2,sv2)
{
	var text="<"+tag+" ";
	if(a1)text+=a1+"="+av1+" ";
	if(a2)text+=a2+"="+av2+" ";
	if(s1||s2)
	{
		text+="style='";
		if(s1)text+=s1+":"+sv1+";";
		if(s2)text+=s2+":"+sv2+";";
		text+="' ";
	}
	text+="></"+tag+">";
	parent.insertAdjacentHTML("BeforeEnd",text);
	return(parent.children[parent.children.length-1]);
}

function createElement(ownerDocument,parent,tag)
{
	parent.insertAdjacentHTML("BeforeEnd","<"+tag+"/>");
	return(parent.children[parent.children.length-1]);
}

function getElementById(wnd,id)
{
	if(id&&wnd)return eval ("wnd."+id);
	else return null;
}

function getElementsByTagName(parent,name)
{
	if(parent) return parent.all.tags(name);
	else return null;
}

function expandMenu(nmenu,popupId,refWnd,dum,ml,mt,mr,mb)
{

	if(!docLoaded)return;
	clearTimeout(nmenu.activePopupTimeout);
	if (nmenu.activePopup&&nmenu.activePopup.id!=popupId+"popup")
		closePopup(nmenu,nmenu.activePopup.id);
	if(popupId=='none')return;
	var rect;
	if(refWnd=='coords'){rect=getClientRect(nmenu,getElementById(window,nmenu.name+"tl"));rect.left=rect.left+ml;rect.top=rect.top+mt;rect.right=rect.left+mr;rect.bottom=rect.top+mb;}else{rect=getClientRect(nmenu,getElementById(window,popupId+"top"));}
	var x;
	var y;
	if(nmenu.menuHorizontal)
	{
		x=rect.left;
		y=rect.bottom+nmenu.popupOffset;
	}
	else
	{
		x=rect.right+nmenu.popupOffset;
		y=rect.top;
	}
	if(nmenu.sepFrame&&!nmenu.openSameFrame)
	{
		var brRect=getBrowserRect(nmenu.popupFrame);
		var wRect=getBrowserRect(window);
		switch (nmenu.menuPos)
		{
		case 0:
			x=brRect.left+nmenu.popupOffset;
			y+=brRect.top-wRect.top;
			break;
		case 1:
			x=brRect.right-nmenu.popupOffset;
			y+=brRect.top-wRect.top;
			break;
		case 2:
			x+=brRect.left-wRect.left;
			y=brRect.top+nmenu.popupOffset;
			break;
		case 3:
			x+=brRect.left-wRect.left;
			y=brRect.bottom-nmenu.popupOffset;
			break;
		}
	}
	var popup=createPopupFromCode(nmenu,popupId,0);
	openPopup(nmenu,popup,x,y,true,null);
	nmenu.activePopup=popup;
}

function collapseMenu(nmenu,popupId)
{
	if(!docLoaded)return;
	var popup=getElementById(nmenu.popupFrame,popupId+"popup");
	if(popup)onPopupOutImpl(nmenu,popup);
}

function expandMenuNS(nmenu,popupId,e,dItem)
{
}

function collapseMenuNS(nmenu,popupId)
{
}

function onDocClick()
{
	var nmn;
	for(nmn=1;nmn<=lastm;nmn++)
	{
		var nmenu=eval("window.m"+nmn);
		if(nmenu&&nmenu.activePopup)closePopup(nmenu,nmenu.activePopup.id);
	}
}

function findFrame(name)
{
	if(parent.frames[name])return parent.frames[name];
	var i;
	for(i=0;i<parent.frames.length;i++){if(parent.frames[i].frames[name])return parent.frames[i].frames[name];}
}

function initializeMenu()
{
	if(docLoaded)return;
	var nmn;
	for(nmn=1;nmn<=lastm;nmn++)
	{
		var nmenu=eval("window.m"+nmn);
		if(nmenu)
		{
			nmenu.popupFrame=(nmenu.sepFrame&&!nmenu.openSameFrame)?findFrame(nmenu.contentFrame):window;
			nmenu.targetFrame=(nmenu.sepFrame)?findFrame(nmenu.cntFrame):window;
			if(!nmenu.mout)addEvent(nmenu.popupFrame.document,"mousedown",onDocClick,false);
		}
	}
	docLoaded=true;
}

function addEvent(obj,event,fun,bubble)
{
	if (obj.addEventListener)
		obj.addEventListener(event,fun,bubble);
	else
	{
		eval("obj.on"+event+"="+fun);
	}
}

function chgBg(nmenu,item,color)
{
	var el=getElementById(window,item);
	if (!IE4)return;
	if (color==0)
	{
		if(!nmenu.bBitmapScheme)el.style.background=nmenu.tlmOrigBg;
		el.style.color=nmenu.tlmOrigCol;
	}
	else
	{
		if(!nmenu.bBitmapScheme&&(color&1))el.style.background=nmenu.tlmHlBg ;
		if(color&2)el.style.color=nmenu.tlmHlCol ;
	}
}

function initializeAll()
{
	var i;
	for(i=0;i<=document.lastLoadHandler;i++)
	{
		eval(document.loadHandlers[i]+'();');
	}
}