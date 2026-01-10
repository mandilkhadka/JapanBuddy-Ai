module ApplicationHelper
  LANGUAGE_DATA = {
    en: { flag: '🇺🇸', name: 'EN' },
    ja: { flag: '🇯🇵', name: 'JP' },
    ne: { flag: '🇳🇵', name: 'NE' }
  }.freeze

  def language_flag(locale)
    LANGUAGE_DATA[locale.to_sym]&.fetch(:flag, '🌐') || '🌐'
  end

  def language_name(locale)
    LANGUAGE_DATA[locale.to_sym]&.fetch(:name, 'EN') || 'EN'
  end

  def available_locales
    LANGUAGE_DATA
  end
end
