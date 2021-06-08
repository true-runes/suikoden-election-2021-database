class Product < ApplicationRecord
  has_many :character_products, dependent: :destroy
  has_many :characters, through: :character_products

  def shorten_name(lang: 'ja')
    if lang == 'en'
      return {
        'Suikoden' => 'S1',
        'Suikoden II' => 'S2',
        'SuikodenII' => 'S2',
        'Suikoden 2' => 'S2',
        'Suikoden2' => 'S2'
      }.fetch(name_en, name_en)
    end

    {
      '幻想水滸伝' => '幻水I'
    }.fetch(name, name)
  end
end
