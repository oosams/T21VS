/ * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   D a t a b a s e   n a m e :     T 2 1                                                                                     * /  
 / *   D B M S   n a m e :             M i c r o s o f t   S Q L   S e r v e r   2 0 1 2                                         * /  
 / *   C r e a t e d   o n :           0 3 - D e c - 2 0   6 : 4 1 : 0 1   P M                                                   * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   T a b l e :   P r o d u c t s                                                                                             * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   t a b l e   S h o p . P r o d u c t s   (  
       P r o d u c t I D                         i n t                                     i d e n t i t y ,  
       C a t e g o r y I D                       i n t                                     n o t   n u l l ,  
       P r o d u c t N a m e                     n v a r c h a r ( 2 5 5 )                 n o t   n u l l ,  
       I s A c t i v e                           t i n y i n t                             n o t   n u l l ,  
       D e s c r i p t i o n                     [ n v a r c h a r ( m a x ) ]             n o t   n u l l ,  
       c o n s t r a i n t   P K _ P R O D U C T S   p r i m a r y   k e y   ( P r o d u c t I D )  
 )  
 g o  
  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 / *   I n d e x :   C a t e g o r y _ P r o d u c t _ F K                                                                       * /  
 / * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = * /  
 c r e a t e   i n d e x   C a t e g o r y _ P r o d u c t _ F K   o n   S h o p . P r o d u c t s   (  
 C a t e g o r y I D   A S C  
 )  
 g o  
  
 