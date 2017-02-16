module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def helper_class(s)
   if(params[:sort].to_s == s)
     return 'hilite'
   else
     return nil
   end
  end
end
