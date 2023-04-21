# frozen_string_literal: true

class AfterSoukyaku < FmRest::Layout('【カード】B_送客後ユーザー')
  attributes(
    open_introduction: 'オープン紹介業者',
    invitation: '営業参加依募集業者',
    participation: '営業参加成立業者',
    nonparticipation: '営業参加不成立業者'
  )
end
