module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  EXCHANGE_RATES = {
    en: 1.0,
    es: 0.77
  }

  def price_in_locale(price, locale = I18n.locale)
    locale ||= :en
    number_to_currency price * EXCHANGE_RATES[locale.to_sym], locale: locale.to_sym
  end
end
