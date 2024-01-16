L2012_Instel : dialog {
    label = "Drawing Setup Sweco";

spacer;

: row {
 : column {
 width = 18;
 : text {
            label = "Standard:"; 
            key = val_stand;
            height = 1.0;
       }}
 : column {
   width = 20;
 : popup_list {
          key = "Standard";
          width = 18;
          fixed_width = true;
          alignment = left;
			  }
}
   }
spacer;
: row {
 : column {
 width = 18;
 : text {
            label = "Language:"; 
            key = val_a;
            height = 1.0;
       }}
 : column {
   width = 20;
 : popup_list {
          key = "Talen";
          width = 18;
          fixed_width = true;
          alignment = left;
			  }
}
   }
   
spacer;

: row {
 : column {
 width = 18;
 : text {
            label = "Scale:"; 
            key = val_b;
            height = 1.0;
       }}
  : column {
   width = 20;
  : popup_list {
          key = "Schalen";
          width = 18;
          fixed_width = true;
          alignment = left;
   }}}
 : row {
  : column {
 width = 18;
  : text {
           label = "";
           alignment = left;
         }}
  : column {
   width = 20;
  : edit_box {
          key = "CustSch";
          width = 18;
          fixed_width = true;
          alignment = left;
  
   }}}
    
spacer;
: row {
 : column {
 width = 18;
 : text {
            label = "Dimensions:"; 
            key = val_c;
            alignment = left;
            height = 1.0;
       }}
      
  : radio_column {    // defines the radio button areas
  key   = "Maten";
  alignment = left;
   width = 20;
  : radio_button 	{        // defines the lightweight radio button
					label = "  Yes";
					key = "ja_r";
					width = 15;
					alignment = left;
					}
 
   
  : radio_button 	{       // defines the old-style polyline radio button
					label = "  No";
					key = "nee_r";
					width = 15;
					alignment = left;
					}
					
					
				}
	  }
	  
	spacer;
	: row {
	 : column {
	 width = 19;
	 : text {
				label = "Dim. Modus:"; 
				key = Modus_c;
				width = 12;
				alignment = left;
				height = 1.0;
		   }}
		  

	  : radio_column {    // defines the radio button areas
		key   = "Modus";
		alignment = left;
	    width = 20;
	  : radio_button {       // defines the old-style polyline radio button
		label = "Classic";
		key = "2";
		alignment = left;
	    }
	  : radio_button {        // defines the lightweight radio button
		label = "Annotative";
		key = "3";
		alignment = left;
	   }
	}
	}

: row {
 : column {
 width = 19;
 : text {
            label = "Dim. Size:"; 
            //key = val_a;
            height = 1.0;
       }}
 : column {
   width = 20;
  : edit_box {
			key = "dim_sz";
			width = 18;
			fixed_width = true;
			alignment = left;
	         }
          }
      }   
   


spacer;
: row {
 : column {
 width = 21;
     : text {
            label = "Dim. Paper Sp.:"; 
            width = 12;
            alignment = left;
            height = 1.0;
       }}
      

  : column {
  width = 18;
      : toggle {
	  alignment = left;
      key = "dim_ps";
      label = "(Advanced Steel)";
	  width = 20;
    }}
}

spacer;
: row {
 : column {
 width = 18;
      : toggle {
      key = "Toggle2D";
      label = "2D Layerset";
    }}
 
 : column {  
   width = 20;
      : toggle {
      key = "Toggle3D";
      label = "3D Layerset";
    }}
}

spacer;        
: row {
  : column {
 width = 19;
  : ok_button {
      width = 15;
      fixed_width = true;
  }}
  : column {
   width = 19;
  : cancel_button {
      width = 15;
      fixed_width = true;
  }}
  }
  
spacer;
}


LabYesNo : dialog {
    label = "";
	key = "Title";
	fixed_width = true;
    width = 40;
   
 spacer;

: row {
 : text {
            label = ""; 
			key = "Title2";
       }
}
 
spacer;      
  spacer;
: row {
    fixed_width = true;
    alignment = centered;
    : cancel_button {
      width = 8;
      key = "delay";
      label = "&No";
      fixed_width = true;
    }
	: ok_button {
	  key = "next";
	  label = "&Yes";
      width = 8;
      fixed_width = true;
    }
  }
spacer; 

}

LabUpdate1 : dialog {
    label = "AutoUpdate";
   
 spacer;

: row {
 : text {
            label = "There is a new version of LAB2012 available."; 
       }
}
 spacer;
: row {
 : text {
            label = "Do u wish to update now?"; 
       }
}

 
spacer;      
  spacer;
: row {
    fixed_width = true;
    alignment = centered;
    : cancel_button {
      width = 8;
      key = "delay";
      label = "Cancel";
      fixed_width = true;
    }
	: ok_button {
	  key = "next";
	  label = "Next >";
      width = 8;
      fixed_width = true;
    }
	: button {
      width = 8;
      key = "settings";
      label = "Settings";
      fixed_width = true;
    }
  }
spacer; 

}

LabUpdate2 : dialog {
    label = "AutoUpdate";
   
 spacer;

: row {
 : text {
			alignment = centered;
            label = "Additional updates:"; 
       }
}

 spacer;
 
 
: row {
  : toggle {
      key = "toggle1";
      label = "Plotter updates";
    }
}
 
 spacer;
 spacer;
 
: row {
    fixed_width = true;
    alignment = centered;
   :  button {
      key = "previous";
	  label = "< Previous";
	  width = 10;
      fixed_width = true;
    }
    : cancel_button {
      width = 10;
      key = "delay";
      label = "Cancel";
      fixed_width = true;
    }
	: ok_button {
      width = 10;
      key = "install";
      label = "Install";
      fixed_width = true;
    }
  }
spacer; 

}

L12_StlExist : dialog {
    label = "WARNING!";
   
 spacer;

: row {
	alignment = centered;
    : text {
      label = "Existing dimension in STIJL A, STIJL B or STIJL C detected."; 
	  alignment = centered;
	}
 }
: row {
	alignment = centered;
    : text {
      label = "You are about to reset all dimensions."; 
	  alignment = centered;
	}
}
: row {
	alignment = centered;
    : text {
      label = "All customisations to your existing dimensions will be lost."; 
	  alignment = centered;
	}
}
: row {
	alignment = centered;
    : text {
      label = "Do you really want to do this? "; 
	  alignment = centered;
	}
}

 spacer;
 
: row {
    fixed_width = true;
	alignment = centered;
	: ok_button {
      key = "No";
      label = "No";
      width = 12;
	  fixed_width = true;
    }
	: button {
      key = "Yes";
      label = "Yes";
      width = 12;
	  fixed_width = true;
    }
spacer; 
}
}

L12_Settings : dialog {
    label = "Global Options";
 : boxed_row {
	alignment = right;
	label = "Choose your discipline"; 
  : text {
            label = "Discipline:"; 
			alignment = right;
       }
  : popup_list {
          key = "Discipline";
          width = 4;
		  fixed_width = true;
	      alignment = left;
   }}
   
 spacer;
   : row {
      : boxed_radio_row {
         label = "When to check for updates?";
         key   = "Radio1";
         alignment = centered;
         : radio_button {
            label = "Every day";
            key   = "1";
         }
		 : radio_button {
            label = "Every 10 days";
            key   = "2";
         }
         : radio_button {
            label = "Every month";
            key   = "3";
         }
         : radio_button {
            label = "Never Check";
            key   = "9";
         }
      }}
	: boxed_row {
		  label = "Autosave after x commands";
	  : edit_box {
	      label = "(0 = disable)";
          key = "Check1";
          width = 18;
          fixed_width = true;
          alignment = left;
     }
     }
: boxed_row {
	alignment = right;
	label = "Update path location";
    : text {
      label = ""; 
      key = "u_path_text";
	  alignment = right;
 }
 	: button {
      key = "u_path_but";
      label = "Path";
      width = 6;
	  fixed_width = true;
	  alignment = left;
	  
    }
 }

: boxed_row {
	alignment = right;
	label = "Excel path location";
    : text {
      label = ""; 
      key = "e_path_text";
	  alignment = right;
 }
 	: button {
      key = "e_path_but";
      label = "Path";
      width = 6;
	  fixed_width = true;
	  alignment = left;
	  
    }
 }
: row {
    fixed_width = true;
    alignment = centered;
    : cancel_button {
      width = 10;
      key = "back";
      label = "Cancel";
      fixed_width = true;
    }
	: ok_button {
      width = 10;
      key = "ok";
      label = "OK";
      fixed_width = true;
    }
  }
spacer; 

}