	dw 00788 ;national dex no
        
        db  70,  75, 115,  85,  95, 130
        evs  0,   0,   0,   0,   0,   3
        ;   hp  atk  def  spd  sat  sdf
        
        db WATER, FAIRY ; type
        db 3 ; catch rate
        db 257 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn GENDERLESS, 3 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/tapu_fini/front.dimensions"  
        db MISTY_SURGE, MISTY_SURGE     ; abilities
        db TELEPATHY    ; hidden ability
        db GROWTH_SLOW ; growth rate
        dn EGG_NONE ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end