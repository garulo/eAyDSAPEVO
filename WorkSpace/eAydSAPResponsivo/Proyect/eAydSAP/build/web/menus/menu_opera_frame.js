// script generated by Xtreeme SiteXpert
// sitemap and search engine creator
// http://www.xtreeme.com/sitexpert
// Copyright(C) 2001-2002 Xtreeme GmbH

function buildPopup(nmenu,arrayName,level)
{
	var levelAttribs;
	if (level > nmenu.maxlev) {levelAttribs = eval ("nmenu.lev" + nmenu.maxlev) ;} else {levelAttribs = eval ("nmenu.lev" + level) ;}
	var popupName=arrayName+"popup";
	nmenu.popupFrame.document.write("<div id='"+popupName+"' style='position:absolute;padding-left:"+nmenu.bord+";padding-top:"+nmenu.bord+";padding-right:"+nmenu.bord+";padding-bottom:"+nmenu.bord+";visibility:hidden'>");
	var array=eval("parent.frames['tree']."+arrayName);
	var arrayItem;
	var ali=" align='"+(nmenu.popAlign==1?'center':(nmenu.popAlign==2?'right':'left'))+"' ";
	for(arrayItem=0;arrayItem<array.length/3;arrayItem++)
	{
		if (arrayItem>0&&nmenu.sep)nmenu.popupFrame.document.write("<div id='"+popupName+arrayItem+'sep'+"' style='background-color:"+nmenu.borderCol+";height:"+nmenu.sep+";width:"+(nmenu.popupWidth-nmenu.bord*2)+"'></div>");
		var popupArray=(array[arrayItem*3+2])?(arrayName+"_"+parseInt(arrayItem+1)):null;
		var absPath=parent.frames['tree'].absPath;
		var iconTag=(array[arrayItem*3+2]?"<IMG SRC=\'"+unescape(absPath)+nmenu.imgFolder+"/sxicona.gif\' BORDER=0 WIDTH="+nmenu.iconSize+" HEIGHT="+nmenu.iconSize+" HSPACE=0 ALIGN=RIGHT>":"");
		var itemText=array[arrayItem*3];
		var style="width:"+(nmenu.popupWidth-nmenu.bord*2-nmenu.vertSpace*2)+";padding-left:"+nmenu.vertSpace+";padding-top:"+nmenu.vertSpace+";padding-bottom:"+nmenu.vertSpace;
		style+=";font-size:"+levelAttribs[0]+";width:"+(nmenu.popupWidth-nmenu.vertSpace*2-nmenu.bord*2)+";color:"+levelAttribs[3]+";font-family:"+levelAttribs[6];
		if(levelAttribs[1])style+=";font-weight:bold";
		if(levelAttribs[2])style+=";font-style:italic";
		nmenu.popupFrame.document.write("<div"+ali+"id='"+(popupName+arrayItem)+"' style=\""+style+"\">"+iconTag+itemText+"</div>");
	}
	nmenu.popupFrame.document.write("<div style='height:0'>&nbsp;</div>");
	nmenu.popupFrame.document.write("</div>");
	for(arrayItem=0;arrayItem<array.length/3;arrayItem++)
	{
		if(array[arrayItem*3+2]) buildPopup(nmenu,arrayName+'_'+(arrayItem+1),level+1);
	}
}

function findFrame(name)
{
	if(parent.frames[name])return parent.frames[name];
	var i;
	for(i=0;i<parent.frames.length;i++){if(parent.frames[i].frames[name])return parent.frames[i].frames[name];}
}

function buildPopups()
{
	var nmn;
	var pf;
	for(nmn=1;nmn<=parent.frames['tree'].lastm;nmn++)
	{
		var nmenu=eval("parent.frames['tree'].m"+nmn);
		if(nmenu)
		{
			nmenu.popupFrame=(nmenu.sepFrame&&!nmenu.openSameFrame)?findFrame(nmenu.contentFrame):parent.frames['tree'];
			targetFrame=(nmenu.sepFrame)?findFrame(nmenu.cntFrame):parent.frames['tree'];
			var i=1;
			while(true)
			{
				var menu=eval("parent.frames['tree']."+nmenu.name+"mn"+i);
				if (!menu)break;
				buildPopup(nmenu,nmenu.name+'mn'+i,0);
				i++;
			}
			pf=nmenu.popupFrame;
		}
	}
	if(pf)pf.document.close();
}

var Opera=(navigator.userAgent.indexOf('Opera')!=-1)||(navigator.appName.indexOf('Opera')!=-1)||(window.opera);
var Opera7=(Opera&&document.createElement!=null&&document.addEventListener!=null);
if(Opera&&!Opera7&&parent&&parent.frames&&parent.frames['tree']&&parent.frames['tree'].lastm){buildPopups();}
