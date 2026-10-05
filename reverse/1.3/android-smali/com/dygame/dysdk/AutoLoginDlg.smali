.class public Lcom/dygame/dysdk/AutoLoginDlg;
.super Landroid/app/Dialog;
.source "AutoLoginDlg.java"

# interfaces
.implements Lcom/dygame/common/unit/DYUnit$Target;
.implements Landroid/view/View$OnClickListener;


# instance fields
.field protected mCancel:Z

.field protected mWidget:Lcom/dygame/common/unit/DYWidgetUnit;


# direct methods
.method public constructor <init>(Landroid/content/Context;I)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "theme"    # I

    .prologue
    const/4 v1, 0x0

    .line 27
    invoke-direct {p0, p1, p2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    .line 23
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/dygame/dysdk/AutoLoginDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 24
    iput-boolean v1, p0, Lcom/dygame/dysdk/AutoLoginDlg;->mCancel:Z

    .line 29
    sget v0, Lcom/dygame/dysdk/R$layout;->dysdk_auto_login:I

    invoke-virtual {p0, v0}, Lcom/dygame/dysdk/AutoLoginDlg;->setContentView(I)V

    .line 30
    invoke-virtual {p0, v1}, Lcom/dygame/dysdk/AutoLoginDlg;->setCancelable(Z)V

    .line 32
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->initWidgets()V

    .line 34
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->tryAutoLogin()V

    .line 35
    return-void
.end method


# virtual methods
.method public dismiss()V
    .locals 0

    .prologue
    .line 157
    invoke-super {p0}, Landroid/app/Dialog;->dismiss()V

    .line 158
    invoke-static {p0}, Lcom/dygame/common/unit/DYUnit;->removeAllUnits(Lcom/dygame/common/unit/DYUnit$Target;)V

    .line 159
    return-void
.end method

.method public findView(I)Landroid/view/View;
    .locals 1
    .param p1, "resId"    # I

    .prologue
    .line 151
    invoke-virtual {p0, p1}, Lcom/dygame/dysdk/AutoLoginDlg;->findViewById(I)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method protected initWidgets()V
    .locals 9

    .prologue
    const/4 v6, 0x1

    const/4 v8, 0x0

    .line 38
    const-class v4, Lcom/dygame/common/unit/DYWidgetUnit;

    invoke-static {p0, v4}, Lcom/dygame/common/unit/DYUnit;->addUnit(Lcom/dygame/common/unit/DYUnit$Target;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/dygame/common/unit/DYWidgetUnit;

    iput-object v4, p0, Lcom/dygame/dysdk/AutoLoginDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 41
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v4

    sget-object v5, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    invoke-interface {v4, v5, v8}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    .line 44
    .local v1, "isGuest":Z
    iget-object v4, p0, Lcom/dygame/dysdk/AutoLoginDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v5, Lcom/dygame/dysdk/R$id;->change_accout:I

    invoke-virtual {v4, v5}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/Button;

    .line 45
    .local v0, "btn":Landroid/widget/Button;
    invoke-virtual {v0, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 47
    iget-object v4, p0, Lcom/dygame/dysdk/AutoLoginDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v5, Lcom/dygame/dysdk/R$id;->user_account:I

    invoke-virtual {v4, v5}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    .line 48
    .local v3, "tvAccount":Landroid/widget/TextView;
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->getContext()Landroid/content/Context;

    move-result-object v4

    sget v5, Lcom/dygame/dysdk/R$string;->dysdk_welcome:I

    invoke-virtual {v4, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 50
    .local v2, "patt":Ljava/lang/String;
    if-eqz v1, :cond_0

    .line 51
    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_bind_text:I

    invoke-virtual {v0, v4}, Landroid/widget/Button;->setText(I)V

    .line 52
    new-array v4, v6, [Ljava/lang/Object;

    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->getContext()Landroid/content/Context;

    move-result-object v5

    sget v6, Lcom/dygame/dysdk/R$string;->dysdk_guest_login:I

    invoke-virtual {v5, v6}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v4, v8

    invoke-static {v2, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 58
    :goto_0
    return-void

    .line 54
    :cond_0
    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_switch_text:I

    invoke-virtual {v0, v4}, Landroid/widget/Button;->setText(I)V

    .line 55
    new-array v4, v6, [Ljava/lang/Object;

    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v5

    sget-object v6, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    const-string v7, ""

    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v4, v8

    invoke-static {v2, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_0
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3
    .param p1, "arg0"    # Landroid/view/View;

    .prologue
    .line 163
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    .line 164
    .local v0, "resId":I
    sget v1, Lcom/dygame/dysdk/R$id;->change_accout:I

    if-ne v0, v1, :cond_0

    .line 165
    const-string v1, "DYGame"

    const-string v2, "change_accout"

    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 166
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->onClickChangeAccount()V

    .line 168
    :cond_0
    return-void
.end method

.method public onClickChangeAccount()V
    .locals 4

    .prologue
    .line 131
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/dygame/dysdk/AutoLoginDlg;->mCancel:Z

    .line 132
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    sget-object v2, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    const/4 v3, 0x0

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 135
    .local v0, "isGuest":Z
    if-eqz v0, :cond_0

    .line 136
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/dygame/dysdk/DYSdkHelper;->showBindDlg(Landroid/content/Context;)V

    .line 145
    :goto_0
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->dismiss()V

    .line 146
    return-void

    .line 138
    :cond_0
    invoke-virtual {p0}, Lcom/dygame/dysdk/AutoLoginDlg;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/dygame/dysdk/DYSdkHelper;->showLoginDlg(Landroid/content/Context;)V

    .line 140
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    sget-object v2, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 141
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    sget-object v2, Lcom/dygame/dysdk/DYSDK;->TEMP_PASS:Ljava/lang/String;

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 142
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    sget-object v2, Lcom/dygame/dysdk/DYSDK;->TEMP_IS_GUEST:Ljava/lang/String;

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    goto :goto_0
.end method

.method protected tryAutoLogin()V
    .locals 4

    .prologue
    .line 61
    new-instance v0, Lcom/dygame/dysdk/AutoLoginDlg$1;

    invoke-direct {v0, p0}, Lcom/dygame/dysdk/AutoLoginDlg$1;-><init>(Lcom/dygame/dysdk/AutoLoginDlg;)V

    .line 127
    .local v0, "h":Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;
    const/4 v1, 0x0

    const-wide/16 v2, 0x7d0

    invoke-virtual {v0, v1, v2, v3}, Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;->sendEmptyMessageDelayed(IJ)Z

    .line 128
    return-void
.end method
