class TasksController < ApplicationController
  def index   # all　すべてのレコードを取得する
    @tasks = Task.all
  end

  def show    #GET パスは/tasks/:id　特定のtaskを表示　※詳細ページのidが取得できればok
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create    #タスク新規作成
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = 'タスクが投稿されました'    # =>flash は、Controller から View へメッセージを渡すときの変数であり、ハッシュ
      redirect_to @task
    else
      flash[:danger] = 'タスクが投稿されません'
      render :new
    end
  end

  def edit
  @task = Task.find(params[:id])    # editするidが知りたい
  end

  def update  # 編集 
  @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = 'タスクが編集されました' 
      redirect_to @task   #tasks/id（タスク詳細ページ）にある「編集ページへ」リンクをクリック
    else
      flash.now[:danger] = 'タスクが編集されませんでした'
      render :new
    end
  end
  
  def destroy
  @task = Task.find(params[:id])
  @task.destroy

  flash[:success] = 'タスクが削除されました'
  redirect_to tasks_path
  end
end

private   #privateはそれ以降のメソッドがアクションではなく、そのクラス内だけで使用するメソッドだと明示するものです

def task_params
  params.require(:task).permit(:content)
end


#newからcreateへ送られてきたフォームの内容はparams[:task]に入っていますが、
#そのまま使用するとセキュリティ上の問題があります。なので、
#ストロングパラメータというフィルタを使用します。
#ストロングパラメータに関して
#:contentだけが必要なカラムの場合、このように記述します。