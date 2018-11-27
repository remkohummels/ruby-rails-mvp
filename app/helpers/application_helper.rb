module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
        autolink: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        lax_html_blocks: true,
        strikethrough: true,
        superscript: true,
        space_after_headers: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def asset_exists?(subdirectory, filename)
    File.exists?(File.join(Rails.root, 'app', 'assets', subdirectory, filename))
  end

  def image_exists?(image)
    asset_exists?('images', image)
  end

  def javascript_exists?(script)
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('javascripts', "#{script}.js#{extension}") || asset_exists?('javascripts', "#{script}#{extension}")
    end
  end

  def stylesheet_exists?(stylesheet)
    extensions = %w(.scss .erb .scss.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('stylesheets', "#{stylesheet}.css#{extension}") || asset_exists?('stylesheets', "#{stylesheet}#{extension}")
    end
  end

  def site_url(path)
    (URI.parse(root_url) + path).to_s
  end

  def to_currency(usd_amount)
    @currency.convert(usd_amount)
  end
end
