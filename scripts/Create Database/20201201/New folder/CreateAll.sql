/ * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D a t a b a s e   n a m e :     T 2 1                                                                                     * /  
 / *   D B M S   n a m e :             M i c r o s o f t   S Q L   S e r v e r   2 0 1 2                                         * /  
 / *   C r e a t e d   o n :           0 1 - D e c - 2 0   9 : 3 9 : 0 5   P M                                                   * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
  
  
 d r o p   d a t a b a s e   T 2 1  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D a t a b a s e :   T 2 1                                                                                                 * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   d a t a b a s e   T 2 1  
 o n  
 G O  
  
 u s e   T 2 1  
 G O  
  
 i s q l   C o n f i g . s q l  
 G O  
  
 i s q l   L o g s . s q l  
 G O  
  
 i s q l   M a s t e r . s q l  
 G O  
  
 i s q l   R e p o r t i n g . s q l  
 G O  
  
 i s q l   S t a g i n g . s q l  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D o m a i n :   [ n v a r c h a r ( m a x ) ]                                                                             * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   t y p e   [ n v a r c h a r ( m a x ) ]  
       f r o m   n v a r c h a r ( M a x )  
 G O  
  
 i s q l   A d d r e s s C u s t o m e r . s q l  
 G O  
  
 i s q l   A d d r e s s E m p l o y e e . s q l  
 G O  
  
 i s q l   A d d r e s s e s . s q l  
 G O  
  
 i s q l   C a t e g o r i e s . s q l  
 G O  
  
 i s q l   C i t i e s . s q l  
 G O  
  
 i s q l   C o n t a c t C u s t o m e r . s q l  
 G O  
  
 i s q l   C o n t a c t E m p l o y e e . s q l  
 G O  
  
 i s q l   C o n t a c t s . s q l  
 G O  
  
 i s q l   C o u n t r i e s . s q l  
 G O  
  
 i s q l   C u s t o m e r s . s q l  
 G O  
  
 i s q l   E m p l o y e e s . s q l  
 G O  
  
 i s q l   E r r o r L o g s . s q l  
 G O  
  
 i s q l   E v e n t L o g s . s q l  
 G O  
  
 i s q l   O p e r a t i o n R u n s . s q l  
 G O  
  
 i s q l   O p e r a t i o n S t a t u s e s . s q l  
 G O  
  
 i s q l   O p e r a t i o n s . s q l  
 G O  
  
 i s q l   O r d e r D e t a i l s . s q l  
 G O  
  
 i s q l   O r d e r s . s q l  
 G O  
  
 i s q l   P a y m e n t s . s q l  
 G O  
  
 i s q l   P r o d u c t s . s q l  
 G O  
  
 i s q l   R e g i o n s . s q l  
 G O  
  
 i s q l   V e r s i o n T y p e s . s q l  
 G O  
  
 i s q l   V e r s i o n s . s q l  
 G O  
  
 i s q l   W a r e h o u s e . s q l  
 G O  
  
 a l t e r   t a b l e   M a s t e r . A d d r e s s C u s t o m e r  
       a d d   c o n s t r a i n t   F K _ C U S T O M E R S _ A D D R E S S C U S T O M E R   f o r e i g n   k e y   ( C u s t o m e r I D )  
             r e f e r e n c e s   M a s t e r . C u s t o m e r s   ( C u s t o m e r I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . A d d r e s s C u s t o m e r  
       a d d   c o n s t r a i n t   F K _ A D D R E S S E S _ A D D R E S S C U S T O M E R   f o r e i g n   k e y   ( A d d r e s s I D )  
             r e f e r e n c e s   M a s t e r . A d d r e s s e s   ( A d d r e s s I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . A d d r e s s E m p l o y e e  
       a d d   c o n s t r a i n t   F K _ E M P L O Y E E S _ A D D R E S S E M P L O Y E E   f o r e i g n   k e y   ( E m p l o y e e I D )  
             r e f e r e n c e s   M a s t e r . E m p l o y e e s   ( E m p l o y e e I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . A d d r e s s E m p l o y e e  
       a d d   c o n s t r a i n t   F K _ A D D R E S S E S _ A D D R E S S E M P L O Y E E   f o r e i g n   k e y   ( A d d r e s s I D )  
             r e f e r e n c e s   M a s t e r . A d d r e s s e s   ( A d d r e s s I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . A d d r e s s e s  
       a d d   c o n s t r a i n t   F K _ C I T I E S _ A D D R E S S E S   f o r e i g n   k e y   ( C i t y I D )  
             r e f e r e n c e s   M a s t e r . C i t i e s   ( C i t y I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . C i t i e s  
       a d d   c o n s t r a i n t   F K _ C O U N T R I E S _ C I T I E S   f o r e i g n   k e y   ( C o u n t r y I D )  
             r e f e r e n c e s   M a s t e r . C o u n t r i e s   ( C o u n t r y I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . C i t i e s  
       a d d   c o n s t r a i n t   F K _ R E G I O N S _ C I T I E S   f o r e i g n   k e y   ( R e g i o n I D )  
             r e f e r e n c e s   M a s t e r . R e g i o n s   ( R e g i o n I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . C o n t a c t C u s t o m e r  
       a d d   c o n s t r a i n t   F K _ C U S T O M E R S _ C O N T A C T C U S T O M E R   f o r e i g n   k e y   ( C u s t o m e r I D )  
             r e f e r e n c e s   M a s t e r . C u s t o m e r s   ( C u s t o m e r I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . C o n t a c t C u s t o m e r  
       a d d   c o n s t r a i n t   F K _ C O N T A C T S _ C O N T A C T C U S T O M E R   f o r e i g n   k e y   ( C o n t a c t I D )  
             r e f e r e n c e s   M a s t e r . C o n t a c t s   ( C o n t a c t I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . C o n t a c t E m p l o y e e  
       a d d   c o n s t r a i n t   F K _ E M P L O Y E E S _ C O N T A C T E M P L O Y E E   f o r e i g n   k e y   ( E m p l o y e e I D )  
             r e f e r e n c e s   M a s t e r . E m p l o y e e s   ( E m p l o y e e I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . C o n t a c t E m p l o y e e  
       a d d   c o n s t r a i n t   F K _ C O N T A C T S _ C O N T A C T E M P L O Y E E   f o r e i g n   k e y   ( C o n t a c t I D )  
             r e f e r e n c e s   M a s t e r . C o n t a c t s   ( C o n t a c t I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . E m p l o y e e s  
       a d d   c o n s t r a i n t   F K _ E M P L O Y E E S _ E M P L O Y E E S   f o r e i g n   k e y   ( M a n a g e r I D )  
             r e f e r e n c e s   M a s t e r . E m p l o y e e s   ( E m p l o y e e I D )  
 G O  
  
 a l t e r   t a b l e   L o g s . E r r o r L o g s  
       a d d   c o n s t r a i n t   F K _ E V E N T L O G S _ E R R O R L O G S   f o r e i g n   k e y   ( E v e n t I D )  
             r e f e r e n c e s   L o g s . E v e n t L o g s   ( E v e n t I D )  
 G O  
  
 a l t e r   t a b l e   L o g s . E r r o r L o g s  
       a d d   c o n s t r a i n t   F K _ O P E R A T I O N R U N S _ E R R O R L O G S   f o r e i g n   k e y   ( O p e r a t i o n R u n I D )  
             r e f e r e n c e s   L o g s . O p e r a t i o n R u n s   ( O p e r a t i o n R u n I D )  
 G O  
  
 a l t e r   t a b l e   L o g s . E v e n t L o g s  
       a d d   c o n s t r a i n t   F K _ O P E R A T I O N R U N S _ E V E N T L O G S   f o r e i g n   k e y   ( O p e r a t i o n R u n I D )  
             r e f e r e n c e s   L o g s . O p e r a t i o n R u n s   ( O p e r a t i o n R u n I D )  
 G O  
  
 a l t e r   t a b l e   L o g s . O p e r a t i o n R u n s  
       a d d   c o n s t r a i n t   F K _ O P E R A T I O N S T A T U S E S _ O P E R A T I O N R U N S   f o r e i g n   k e y   ( S t a t u s I D )  
             r e f e r e n c e s   L o g s . O p e r a t i o n S t a t u s e s   ( S t a t u s I D )  
 G O  
  
 a l t e r   t a b l e   L o g s . O p e r a t i o n R u n s  
       a d d   c o n s t r a i n t   F K _ O P E R A T I O N S _ O P E R A T I O N R U N S   f o r e i g n   k e y   ( O p e r a t i o n I D )  
             r e f e r e n c e s   L o g s . O p e r a t i o n s   ( O p e r a t i o n I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . O r d e r D e t a i l s  
       a d d   c o n s t r a i n t   F K _ O R D E R S _ O R D E R D E T A I L S   f o r e i g n   k e y   ( O r d e r I D )  
             r e f e r e n c e s   M a s t e r . O r d e r s   ( O r d e r I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . O r d e r D e t a i l s  
       a d d   c o n s t r a i n t   F K _ P R O D U C T S _ O R D E R D E T A I L S   f o r e i g n   k e y   ( P r o d u c t I D )  
             r e f e r e n c e s   M a s t e r . P r o d u c t s   ( P r o d u c t I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . O r d e r s  
       a d d   c o n s t r a i n t   F K _ A D D R E S S E S _ O R D E R S   f o r e i g n   k e y   ( A d d r e s s I D )  
             r e f e r e n c e s   M a s t e r . A d d r e s s e s   ( A d d r e s s I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . O r d e r s  
       a d d   c o n s t r a i n t   F K _ C U S T O M E R S _ O R D E R S   f o r e i g n   k e y   ( C u s t o m e r I D )  
             r e f e r e n c e s   M a s t e r . C u s t o m e r s   ( C u s t o m e r I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . O r d e r s  
       a d d   c o n s t r a i n t   F K _ E M P L O Y E E S _ O R D E R S   f o r e i g n   k e y   ( E m p l o y e e I D )  
             r e f e r e n c e s   M a s t e r . E m p l o y e e s   ( E m p l o y e e I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . O r d e r s  
       a d d   c o n s t r a i n t   F K _ P A Y M E N T S _ O R D E R S   f o r e i g n   k e y   ( P a y m e n t I D )  
             r e f e r e n c e s   M a s t e r . P a y m e n t s   ( P a y m e n t I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . P r o d u c t s  
       a d d   c o n s t r a i n t   F K _ C A T E G O R I E S _ P R O D U C T S   f o r e i g n   k e y   ( C a t e g o r y I D )  
             r e f e r e n c e s   M a s t e r . C a t e g o r i e s   ( C a t e g o r y I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . R e g i o n s  
       a d d   c o n s t r a i n t   F K _ C O U N T R I E S _ R E G I O N S   f o r e i g n   k e y   ( C o u n t r y I D )  
             r e f e r e n c e s   M a s t e r . C o u n t r i e s   ( C o u n t r y I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . V e r s i o n s  
       a d d   c o n s t r a i n t   F K _ O P E R A T I O N R U N S _ V E R S I O N S   f o r e i g n   k e y   ( O p e r a t i o n R u n I D )  
             r e f e r e n c e s   L o g s . O p e r a t i o n R u n s   ( O p e r a t i o n R u n I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . V e r s i o n s  
       a d d   c o n s t r a i n t   F K _ V E R S I O N T Y P E S _ V E R S I O N S   f o r e i g n   k e y   ( V e r s i o n T y p e I D )  
             r e f e r e n c e s   M a s t e r . V e r s i o n T y p e s   ( V e r s i o n T y p e I D )  
 G O  
  
 a l t e r   t a b l e   M a s t e r . W a r e h o u s e  
       a d d   c o n s t r a i n t   F K _ P R O D U C T S _ W A R E H O U S E   f o r e i g n   k e y   ( P r o d u c t I D )  
             r e f e r e n c e s   M a s t e r . P r o d u c t s   ( P r o d u c t I D )  
 G O  
  
 