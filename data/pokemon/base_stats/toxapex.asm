	dw 00748 ;national dex no
        
        db  50,  63, 152,  35,  53, 142
        evs  0,   0,   2,   0,   0,   0
        ;   hp  atk  def  spd  sat  sdf
        
        db POISON, WATER ; type
        db 75 ; catch rate
        db 173 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn FEMALE_50, 4 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/toxapex/front.dimensions"  
        db MERCILESS, LIMBER     ; abilities
        db REGENERATOR    ; hidden ability
        db GROWTH_MEDIUM_FAST ; growth rate
        dn EGG_WATER_1 ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end