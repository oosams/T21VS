/ * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D a t a b a s e   n a m e :     T 2 1                                                                                     * /  
 / *   D B M S   n a m e :             M i c r o s o f t   S Q L   S e r v e r   2 0 1 2                                         * /  
 / *   C r e a t e d   o n :           0 1 - D e c - 2 0   9 : 3 9 : 0 5   P M                                                   * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   T a b l e :   C i t i e s                                                                                                 * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   t a b l e   M a s t e r . C i t i e s   (  
       C i t y I D                               i n t                                     n o t   n u l l ,  
       C o u n t r y I D                         s m a l l i n t                           n o t   n u l l ,  
       R e g i o n I D                           s m a l l i n t                           n o t   n u l l ,  
       C i t y L a t i t u d e                   d e c i m a l ( 1 1 , 8 )                 n u l l ,  
       C i t y L o n g i t u d e                 d e c i m a l ( 1 1 , 8 )                 n u l l ,  
       C i t y N a m e                           n v a r c h a r ( 5 0 )                   n o t   n u l l ,  
       c o n s t r a i n t   P K _ C I T I E S   p r i m a r y   k e y   ( C i t y I D )  
 )  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   I n d e x :   C o u n t r y _ C i t y _ F K                                                                               * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   i n d e x   C o u n t r y _ C i t y _ F K   o n   M a s t e r . C i t i e s   (  
 C o u n t r y I D   A S C  
 )  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   I n d e x :   R e g i o n _ C i t y _ F K                                                                                 * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   i n d e x   R e g i o n _ C i t y _ F K   o n   M a s t e r . C i t i e s   (  
 R e g i o n I D   A S C  
 )  
 G O  
  
 