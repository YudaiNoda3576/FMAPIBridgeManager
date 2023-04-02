# frozen_string_literal: true

class Soukyakukanri < FmRest::Layout('送客管理')
  attributes(
    media_name: 'F_外壁／防水',
    name: 'H_氏名',
    tel1: 'K_電話番号1',
    work_date: '完成希望時期',
    contact_time: '連絡希望時間',
    contact_note: '連絡留意事項',
    customer_request: 'ご要望',
    email: 'J_メールアドレス',
    work_type: '施工内容',
    cemetery_name: '霊園名',
    cemetery_addr: '墓所住所'
  )
end
