UnBlank : dialog { label = "UnBlank" ; width = 40 ; height = 27 ;
: row
{
 : list_box { label = "Select items to unblank." ; key = "listbox1" ; width = 25 ; multiple_select = false ;}
 : column {
  : spacer {}
  : column {
   :spacer {}
   : button { label = "UnBlank" ; key = "UnBlank1" ; width = 1 ; fixed_width = true ; }
   : toggle { label = "Zoom when UnBlanking?" ; key = "Tog1" ; value = 1 ; }
   : button { label = "Zoom extents" ; key = "Zoom1" ; width = 1 ; fixed_width = true ; }
   : spacer {}
  }
  : button { label = "Draw Boundry Box" ; key = "BB1" ; width = 1 ; fixed_width = true ; }
  : button { label = "Re-Blank" ; key = "ReBlank1" ; width = 1 ; fixed_width = true ; }
  : button { label = "UnBlank All" ; key = "UnBlank2" ; width = 1 ; fixed_width = true ; }
  : button { label = "Done" ; key = "Cancel" ; is_cancel = true ; width = 1 ; fixed_width = true ; }
  : spacer {}
 }
}
}
//-----------------------------------------------------------------------------------------

SingleSelect : dialog{ label = "Select Item";
: list_box { key = "listbox"; width = 55; height = 25; }
: toggle { key = "toggle1"; }
: text { key = "text1"; }
: row {
 : spacer { width = 1; }
 : button { label = "OK"; is_default = true; allow_accept = true; key = "accept"; width = 8; fixed_width = true; }
 : button { label = "Cancel"; is_cancel = true; key = "cancel"; width = 8; fixed_width = true; }
 : spacer { width = 1;}
}
}
//-------------------------------------------------------------------------------------------

MultiSelect : dialog{ label = "Select Item";
: list_box { key = "listbox"; width = 55; height = 25; multiple_select = true; }
: toggle { key = "toggle1"; }
: text { key = "text1"; }
: row {
 : spacer { width = 1; }
 : button { label = "OK"; is_default = true; allow_accept = true; key = "accept"; width = 8; fixed_width = true; }
 : button { label = "Cancel"; is_cancel = true; key = "cancel"; width = 8; fixed_width = true; }
 : spacer { width = 1;}
}
}
//-------------------------------------------------------------------------------------------

XrefRe : dialog {label = "Xref RePath and ReName."; width = 100; height = 22;

: row {
 : list_box { label = "Drawings (Xref's)"; key = "DwgList"; width = 25; height = 17;}
 : column { height = 10;
  : spacer {}
  : boxed_column {
   : text { key = "text1"; }
   : edit_box { label = "New name for Xref."; key = "NewName"; width = 20; }
   : boxed_column { label = "Path type.";
    : radio_row  { key = "PathType"; width = 20;
     : radio_button { label = "Relative"; key = "PathRel"; }
     : radio_button { label = "Full"; key = "PathFull"; }
     : radio_button { label = "None"; key = "PathNone"; value = 1; }
    }
    : edit_box { label = "Relative path:"; key = "Path"; width = 20; }
   }
   : row {
    : spacer {}
    : button { label = "v Proceed v"; key = "Proceed"; width = 10;}
    : spacer {}
   }
  }
  : boxed_column {
   : list_box { label = "Xref names: Old to New"; key = "XrefList"; width = 22; height = 7; tabs = "10";}
   : row {
    : spacer {}
    : button { label = "Remove selection"; key = "Remove"; fixed_width = true; }
    : spacer {}
   }
  }
 }
}
: row {
 : spacer {}
 : button { label = "Process current directory"; key = "Accept"; is_default = true; allow_accept = true; width = 8; fixed_width = true; }
 : button { label = "Select new directory"; key = "NewDir"; width = 8; fixed_width = true; }
 : button { label = "Cancel"; key = "Cancel"; is_cancel = true; width = 8; fixed_width = true; }
 : spacer {}
}
}

//---------------------------------------------------------------------------------------

MyPropsTest : dialog { label = "Properties to edit.";
: text { label = "Thanks Michael Puckett!!  @  www.theswamp.org"; }
: column {
 : list_box { label = "List of properties to modify"; key = "PropsListbox"; height = 25; width = 80; tabs = 40;}
 : text { key = "TextLabel"; }
 : edit_box { key = "PropsEditbox"; }
 : row {
  : spacer {}
  : button { label = "Pick point"; key = "PickPt"; }
  : button { label = "Pick from list"; key = "PickList"; }
  : button { label = "Help"; key = "HelpProp"; }
  : spacer {}
 }
 : row {
  : spacer {}
  : button { label = "Apply"; key = "accept"; allow_accept = true; is_default = true; }
  : button { label = "Done"; key = "cancel"; is_cancel = true; }
  : spacer {}
 }
 : text { key = "TextResults"; }
}
}

//-------------------------------------------------------------------------------------------

MyPropsList : dialog { label = "Select item from list.";
: list_box { key = "PropsListbox2"; height = 20; width = 40; }
: button { label = "Cancel"; key = "cancel"; is_cancel = true; }
}

//--------------------------------------------------------------------------------------------

AttListDialog : dialog { label = "Attribute tags for blocks selected.";
: column {
 : list_box { label = "Attribute tags                                 Number of attribute(s)."; key = "AttListbox"; width = 60; height = 20; tabs = 30; }
 : row {
  : text { key = "AttTextLabel"; }
  : edit_box { key = "AttEditbox"; }
  : button { label = "Pick Ext."; key = "PickExisting"; width = 10; fixed_width = true; }
 }
 : row {
  : button { label = "List Prompts"; key = "PromptList"; }
  : button { label = "Apply"; key = "Accept"; }
  : button { label = "Done"; key = "Cancel"; is_cancel = true; }
 }
}
}
