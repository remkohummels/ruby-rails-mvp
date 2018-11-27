module ItemsHelper
  def item_time_left (item)
    time = item.end_date
    content_tag(:div, :class => "timeleftbox clearfix") do
      if time > DateTime.now
        content_tag(:div, :class => "bid_timer clearfix", 'data-time' => time.strftime("%FT%T%:z")) do
        end
      else
        content_tag(:div, :class => "ea_finished") do
          html = content_tag(:span, 'Auction Finished', :class => "bz-title")
          # html += content_tag(:span, "#{item.winner.full_name} was the winning bidder") if item.winner
          # if item.winner
          #   html += link_to user_path(item.winner) do
          #     "#{item.winner.full_name}  was the winning bidder"
          #   end
          # end
          html
        end
      end
    end
  end

  def similar_items(item)
    Item.where(:location=>item.location,:category_id=>item.category_id).limit(4)
  end

  def popular_items(item)
    Item.where(:location=>item.location).order("views_counter").limit(4)
  end

  def all_popular_items()
    Item.order("views_counter").limit(4)
  end

  def seller_items(seller)
    Item.where(:user_id=>seller.id)
  end
end
