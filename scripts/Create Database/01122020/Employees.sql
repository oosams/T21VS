/ * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D a t a b a s e   n a m e :     T 2 1                                                                                     * /  
 / *   D B M S   n a m e :             M i c r o s o f t   S Q L   S e r v e r   2 0 1 2                                         * /  
 / *   C r e a t e d   o n :           0 3 - D e c - 2 0   6 : 4 1 : 0 1   P M                                                   * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   T a b l e :   E m p l o y e e s                                                                                           * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   t a b l e   S h o p . E m p l o y e e s   (  
       E m p l o y e e I D                       i n t                                     i d e n t i t y ,  
       M a n a g e r I D                         i n t                                     n u l l ,  
       R o l e T i t l e                         n v a r c h a r ( 2 5 5 )                 n o t   n u l l ,  
       H i r e D a t e                           d a t e t i m e                           n o t   n u l l ,  
       I s A c t i v e                           t i n y i n t                             n o t   n u l l ,  
       c o n s t r a i n t   P K _ E M P L O Y E E S   p r i m a r y   k e y   ( E m p l o y e e I D )  
 )  
 g o  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   I n d e x :   E m p l o y e e _ E m p l o y e e _ F K                                                                     * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   i n d e x   E m p l o y e e _ E m p l o y e e _ F K   o n   S h o p . E m p l o y e e s   (  
 M a n a g e r I D   A S C  
 )  
 g o  
  
 