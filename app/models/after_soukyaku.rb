# frozen_string_literal: true

class AfterSoukyaku < FmRest::Layout('【カード】B_送客後ユーザー')
  attributes(
    open_introduction: 'オープン紹介業者',
    invitation: '営業参加依募集業者',
    participation: '営業参加成立業者',
    nonparticipation: '営業参加不成立業者'
  )

  def update_contractor_fields(params)
    update(
      open_introduction: updated_field(open_introduction, params[:open_introduction]),
      invitation: updated_field(invitation, params[:invitation]),
      participation: updated_field(participation, params[:participation]),
      nonparticipation: updated_field(nonparticipation, params[:nonparticipation])
    )
  end

  private

  def updated_field(original_data, new_data)
    return original_data if new_data.nil?
    return new_data.gsub(',', "\n") if original_data.empty?

    "#{original_data}\n#{new_data.gsub(',', "\n")}"
  end
end
