	dw 00211 ;national dex no
        
        db  65,  95,  85,  85,  55,  55
        evs  0,   1,   0,   0,   0,   0
        ;   hp  atk  def  spd  sat  sdf
        
        db WATER, POISON ; type
        db 45 ; catch rate
        db 88 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn FEMALE_50, 4 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/qwilfish/front.dimensions"  
        db POISON_POINT, SWIFT_SWIM     ; abilities
        db INTIMIDATE    ; hidden ability
        db GROWTH_MEDIUM_FAST ; growth rate
        dn EGG_WATER_2 ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end