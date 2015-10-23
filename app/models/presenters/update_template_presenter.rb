class UpdateTemplatePresenter

  def initialize(update)
    @update = update
  end

  def email_html
    <<-eos
      <table>
        <tr>
          <td>
            <img src='#{@update.contact.photo_url}'>
          </td>
          <td>
            #{@update.content}
          </td>
        </tr>
      </table>
    eos
  end

end
