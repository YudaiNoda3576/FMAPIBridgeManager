# frozen_string_literal: true

class Soukyakukanri < FmRest::Layout('送客管理')
  attributes(
    media_name: 'F_外壁／防水',
    prefecture: 'E_都道府県',
    name: 'H_氏名',
    tel1: 'K_電話番号1',
    building_type: '建物の種類',
    construction_type: '工事種別',
    work_date: '完成希望時期',
    contact_time: 'AA_電話確認', # 本来は[連絡希望時間]だがこの名前のフィールドが存在しないので、一旦違うものに入れてある
    contact_note: 'X_最終架電結果', # 本来は[連絡留意事項]だがこの名前のフィールドが存在しないので、一旦違うものに入れてある
    customer_request: 'ご要望',
    email: 'J_メールアドレス',
    area: '建物の面積',
    floor: '建物の階数',
    budget: '予算',
    work_type: '施工内容',
    building_age: '建物の築年数',
    cemetery_name: '霊園名',
    cemetery_addr: '墓所住所',
    tel2: 'L_電話番号2',
    kana: 'I_フリガナ'
  )
end
