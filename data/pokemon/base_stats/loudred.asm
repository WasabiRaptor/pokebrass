	dw 00294 ;national dex no
        
        db  84,  71,  43,  48,  71,  43
        evs  2,   0,   0,   0,   0,   0
        ;   hp  atk  def  spd  sat  sdf
        
        db NORMAL, NORMAL ; type
        db 120 ; catch rate
        db 126 ; base exp
        db NO_ITEM, NO_ITEM ; items
        dn FEMALE_50, 4 ; gender, step cycles to hatch
        INCBIN "gfx/pokemon/loudred/front.dimensions"  
        db SOUNDPROOF, SOUNDPROOF     ; abilities
        db SCRAPPY    ; hidden ability
        db GROWTH_MEDIUM_SLOW ; growth rate
        dn EGG_MONSTER, EGG_FIELD ; egg groups
        
        ; tm/hm learnset
        tmhm                                            
        ; end