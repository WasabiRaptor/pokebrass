	dw 00235 ;national dex no
        
        db  55,  20,  35,  75,  20,  45
        evs  0,   0,   0,   1,   0,   0
        ;   hp  atk  def  spd  sat  sdf
        
        db NORMAL, NORMAL ; type
        db 45 ; catch rate
        db 88 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn FEMALE_50, 4 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/smeargle/front.dimensions"  
        db OWN_TEMPO, TECHNICIAN     ; abilities
        db MOODY    ; hidden ability
        db GROWTH_FAST ; growth rate
        dn EGG_FIELD ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end