/ * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D a t a b a s e   n a m e :     T 2 1                                                                                     * /  
 / *   D B M S   n a m e :             M i c r o s o f t   S Q L   S e r v e r   2 0 1 2                                         * /  
 / *   C r e a t e d   o n :           0 1 - D e c - 2 0   9 : 3 9 : 0 5   P M                                                   * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   T a b l e :   V e r s i o n s                                                                                             * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   t a b l e   M a s t e r . V e r s i o n s   (  
       V e r s i o n I D                         i n t                                     n o t   n u l l ,  
       V e r s i o n T y p e I D                 i n t                                     n o t   n u l l ,  
       O p e r a t i o n R u n I D               i n t                                     n o t   n u l l ,  
       V e r s i o n N u m b e r                 i n t                                     n o t   n u l l ,  
       D e s c r i p t i o n                     [ n v a r c h a r ( m a x ) ]             n o t   n u l l ,  
       S t a r t D a t e                         d a t e t i m e                           n o t   n u l l ,  
       E n d D a t e                             d a t e t i m e                           n o t   n u l l   d e f a u l t   ' 9 9 9 9 - 3 1 - 1 2 ' ,  
       c o n s t r a i n t   P K _ V E R S I O N S   p r i m a r y   k e y   ( V e r s i o n I D )  
 )  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   I n d e x :   V e r s i o n T y p e _ V e r s i o n _ F K                                                                 * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   i n d e x   V e r s i o n T y p e _ V e r s i o n _ F K   o n   M a s t e r . V e r s i o n s   (  
 V e r s i o n T y p e I D   A S C  
 )  
 G O  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   I n d e x :   O p e r a t i o n R u n _ V e r s i o n _ F K                                                               * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   i n d e x   O p e r a t i o n R u n _ V e r s i o n _ F K   o n   M a s t e r . V e r s i o n s   (  
 O p e r a t i o n R u n I D   A S C  
 )  
 G O  
  
 