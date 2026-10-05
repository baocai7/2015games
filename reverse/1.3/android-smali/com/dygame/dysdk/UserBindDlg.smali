.class public Lcom/dygame/dysdk/UserBindDlg;
.super Landroid/app/Dialog;
.source "UserBindDlg.java"

# interfaces
.implements Lcom/dygame/common/unit/DYUnit$Target;
.implements Landroid/view/View$OnClickListener;
.implements Landroid/text/TextWatcher;


# instance fields
.field protected mBtnVerify:Landroid/widget/Button;

.field protected mHandlerCheck:Landroid/os/Handler;

.field protected mLoading:Z

.field protected mWidget:Lcom/dygame/common/unit/DYWidgetUnit;


# direct methods
.method public constructor <init>(Landroid/content/Context;I)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "theme"    # I

    .prologue
    const/4 v1, 0x0

    const/4 v0, 0x0

    .line 34
    invoke-direct {p0, p1, p2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    .line 28
    iput-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 29
    iput-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mHandlerCheck:Landroid/os/Handler;

    .line 30
    iput-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mBtnVerify:Landroid/widget/Button;

    .line 31
    iput-boolean v1, p0, Lcom/dygame/dysdk/UserBindDlg;->mLoading:Z

    .line 36
    sget v0, Lcom/dygame/dysdk/R$layout;->dysdk_user_reg_dialog2:I

    invoke-virtual {p0, v0}, Lcom/dygame/dysdk/UserBindDlg;->setContentView(I)V

    .line 37
    invoke-virtual {p0, v1}, Lcom/dygame/dysdk/UserBindDlg;->setCancelable(Z)V

    .line 39
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserBindDlg;->initWidgets()V

    .line 40
    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .locals 0
    .param p1, "arg0"    # Landroid/text/Editable;

    .prologue
    .line 271
    return-void
.end method

.method public beforeTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0
    .param p1, "arg0"    # Ljava/lang/CharSequence;
    .param p2, "arg1"    # I
    .param p3, "arg2"    # I
    .param p4, "arg3"    # I

    .prologue
    .line 276
    return-void
.end method

.method public dismiss()V
    .locals 0

    .prologue
    .line 105
    invoke-super {p0}, Landroid/app/Dialog;->dismiss()V

    .line 106
    invoke-static {p0}, Lcom/dygame/common/unit/DYUnit;->removeAllUnits(Lcom/dygame/common/unit/DYUnit$Target;)V

    .line 107
    return-void
.end method

.method public findView(I)Landroid/view/View;
    .locals 1
    .param p1, "resId"    # I

    .prologue
    .line 99
    invoke-virtual {p0, p1}, Lcom/dygame/dysdk/UserBindDlg;->findViewById(I)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method protected initWidgets()V
    .locals 5

    .prologue
    .line 43
    const-class v3, Lcom/dygame/common/unit/DYWidgetUnit;

    invoke-static {p0, v3}, Lcom/dygame/common/unit/DYUnit;->addUnit(Lcom/dygame/common/unit/DYUnit$Target;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/dygame/common/unit/DYWidgetUnit;

    iput-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 45
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_back:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 46
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_reigster_immediately:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 47
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->cb_display_passwd:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 49
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->tv_reg_title:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_bind_user_title:I

    .line 50
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(I)V

    .line 51
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_reigster_immediately:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_bind_immediately:I

    .line 52
    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(I)V

    .line 54
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_get_verify_code_bg:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mBtnVerify:Landroid/widget/Button;

    .line 62
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->email_input:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 63
    .local v0, "etAccount":Landroid/widget/EditText;
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 64
    .local v1, "etPass":Landroid/widget/EditText;
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->verify_code_input:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/EditText;

    .line 66
    .local v2, "etVerify":Landroid/widget/EditText;
    invoke-virtual {v0, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 67
    invoke-virtual {v1, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 68
    invoke-virtual {v2, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 70
    new-instance v3, Lcom/dygame/dysdk/UserBindDlg$1;

    invoke-direct {v3, p0}, Lcom/dygame/dysdk/UserBindDlg$1;-><init>(Lcom/dygame/dysdk/UserBindDlg;)V

    iput-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mHandlerCheck:Landroid/os/Handler;

    .line 93
    iget-object v3, p0, Lcom/dygame/dysdk/UserBindDlg;->mHandlerCheck:Landroid/os/Handler;

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    .line 94
    return-void
.end method

.method public onBackPressed()V
    .locals 2

    .prologue
    .line 265
    invoke-super {p0}, Landroid/app/Dialog;->onBackPressed()V

    .line 266
    iget-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->btn_back:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/dygame/dysdk/UserBindDlg;->onClick(Landroid/view/View;)V

    .line 267
    return-void
.end method

.method public onCheckDisplayPasswd()V
    .locals 4

    .prologue
    .line 129
    iget-object v2, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->cb_display_passwd:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/CheckBox;

    .line 130
    .local v0, "cbCheck":Landroid/widget/CheckBox;
    iget-object v2, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 132
    .local v1, "etPass":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/CheckBox;->isChecked()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 134
    invoke-static {}, Landroid/text/method/HideReturnsTransformationMethod;->getInstance()Landroid/text/method/HideReturnsTransformationMethod;

    move-result-object v2

    .line 133
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setTransformationMethod(Landroid/text/method/TransformationMethod;)V

    .line 139
    :goto_0
    return-void

    .line 137
    :cond_0
    invoke-static {}, Landroid/text/method/PasswordTransformationMethod;->getInstance()Landroid/text/method/PasswordTransformationMethod;

    move-result-object v2

    .line 136
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setTransformationMethod(Landroid/text/method/TransformationMethod;)V

    goto :goto_0
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "arg0"    # Landroid/view/View;

    .prologue
    .line 111
    iget-boolean v1, p0, Lcom/dygame/dysdk/UserBindDlg;->mLoading:Z

    if-eqz v1, :cond_1

    .line 126
    :cond_0
    :goto_0
    return-void

    .line 115
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    .line 116
    .local v0, "resId":I
    sget v1, Lcom/dygame/dysdk/R$id;->btn_back:I

    if-ne v0, v1, :cond_2

    .line 117
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserBindDlg;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/dygame/dysdk/DYSdkHelper;->showAutoLoginDlg(Landroid/content/Context;)V

    .line 118
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserBindDlg;->dismiss()V

    goto :goto_0

    .line 119
    :cond_2
    sget v1, Lcom/dygame/dysdk/R$id;->btn_reigster_immediately:I

    if-ne v0, v1, :cond_3

    .line 120
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserBindDlg;->onClickBind()V

    goto :goto_0

    .line 121
    :cond_3
    sget v1, Lcom/dygame/dysdk/R$id;->btn_get_verify_code_bg:I

    if-ne v0, v1, :cond_4

    .line 122
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserBindDlg;->onClickGetVerify()V

    goto :goto_0

    .line 123
    :cond_4
    sget v1, Lcom/dygame/dysdk/R$id;->cb_display_passwd:I

    if-ne v0, v1, :cond_0

    .line 124
    invoke-virtual {p0}, Lcom/dygame/dysdk/UserBindDlg;->onCheckDisplayPasswd()V

    goto :goto_0
.end method

.method public onClickBind()V
    .locals 13

    .prologue
    const/4 v12, 0x0

    .line 164
    iget-object v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v11, Lcom/dygame/dysdk/R$id;->email_input:I

    invoke-virtual {v10, v11}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 165
    .local v0, "etAccount":Landroid/widget/EditText;
    iget-object v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v11, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v10, v11}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 166
    .local v1, "etPass":Landroid/widget/EditText;
    iget-object v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v11, Lcom/dygame/dysdk/R$id;->verify_code_input:I

    invoke-virtual {v10, v11}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/EditText;

    .line 168
    .local v2, "etVerify":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v6

    .line 169
    .local v6, "tName":Ljava/lang/String;
    invoke-static {v6}, Lcom/dygame/dysdk/DYSdkHelper;->isValidMobile(Ljava/lang/String;)Z

    move-result v10

    if-nez v10, :cond_0

    .line 170
    iget-object v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v11, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v10, v11}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v10

    invoke-virtual {v10, v12}, Landroid/view/View;->setVisibility(I)V

    .line 260
    :goto_0
    return-void

    .line 174
    :cond_0
    invoke-virtual {v1}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v7

    .line 175
    .local v7, "tPass":Ljava/lang/String;
    invoke-static {v7}, Lcom/dygame/dysdk/DYSdkHelper;->isValidPasswd(Ljava/lang/String;)Z

    move-result v10

    if-nez v10, :cond_1

    .line 176
    iget-object v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v11, Lcom/dygame/dysdk/R$id;->invalid_passwd:I

    invoke-virtual {v10, v11}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v10

    invoke-virtual {v10, v12}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 180
    :cond_1
    invoke-virtual {v2}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v8

    .line 181
    .local v8, "tVerify":Ljava/lang/String;
    invoke-virtual {v8}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/String;->length()I

    move-result v10

    if-gtz v10, :cond_2

    .line 182
    iget-object v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v11, Lcom/dygame/dysdk/R$id;->invalid_verify_code:I

    invoke-virtual {v10, v11}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v10

    invoke-virtual {v10, v12}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 187
    :cond_2
    const/4 v10, 0x1

    iput-boolean v10, p0, Lcom/dygame/dysdk/UserBindDlg;->mLoading:Z

    .line 188
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v10

    sget-object v11, Lcom/dygame/dysdk/DYSDK;->TEMP_NAME:Ljava/lang/String;

    const-string v12, ""

    invoke-interface {v10, v11, v12}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 189
    .local v4, "oldName":Ljava/lang/String;
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->getPrefs()Landroid/content/SharedPreferences;

    move-result-object v10

    sget-object v11, Lcom/dygame/dysdk/DYSDK;->TEMP_PASS:Ljava/lang/String;

    const-string v12, ""

    invoke-interface {v10, v11, v12}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 191
    .local v5, "oldPass":Ljava/lang/String;
    sget-object v9, Lcom/dygame/dysdk/DYSDK;->URI_BIND_ACCOUNT:Ljava/lang/String;

    .line 192
    .local v9, "uri":Ljava/lang/String;
    new-instance v3, Ljava/util/HashMap;

    invoke-direct {v3}, Ljava/util/HashMap;-><init>()V

    .line 193
    .local v3, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v10, "oldUsername"

    invoke-virtual {v3, v10, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 194
    const-string v10, "oldPassword"

    invoke-virtual {v3, v10, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 195
    const-string v10, "newUsername"

    invoke-virtual {v3, v10, v6}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 196
    const-string v10, "newPassword"

    invoke-virtual {v3, v10, v7}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 197
    const-string v10, "code"

    invoke-virtual {v3, v10, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 199
    new-instance v10, Lcom/dygame/dysdk/UserBindDlg$2;

    invoke-direct {v10, p0}, Lcom/dygame/dysdk/UserBindDlg$2;-><init>(Lcom/dygame/dysdk/UserBindDlg;)V

    invoke-static {v9, v3, v10}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

    goto :goto_0
.end method

.method public onClickGetVerify()V
    .locals 9

    .prologue
    const/4 v8, 0x0

    .line 142
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->leftTickForGetVerify()J

    move-result-wide v2

    .line 143
    .local v2, "left":J
    const-wide/16 v6, 0x0

    cmp-long v6, v2, v6

    if-lez v6, :cond_0

    .line 161
    :goto_0
    return-void

    .line 147
    :cond_0
    iget-object v6, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->email_input:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 148
    .local v0, "etAccount":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    .line 149
    .local v4, "tName":Ljava/lang/String;
    invoke-static {v4}, Lcom/dygame/dysdk/DYSdkHelper;->isValidMobile(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_1

    .line 150
    iget-object v6, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v6

    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 154
    :cond_1
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->saveTickForGetVerify()V

    .line 155
    sget-object v5, Lcom/dygame/dysdk/DYSDK;->URI_GEN_VERIFY:Ljava/lang/String;

    .line 156
    .local v5, "uri":Ljava/lang/String;
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 157
    .local v1, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v6, "telephone"

    invoke-virtual {v1, v6, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 158
    const/4 v6, 0x0

    invoke-static {v5, v1, v6}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

    .line 160
    iget-object v6, p0, Lcom/dygame/dysdk/UserBindDlg;->mHandlerCheck:Landroid/os/Handler;

    invoke-virtual {v6, v8}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    goto :goto_0
.end method

.method public onTextChanged(Ljava/lang/CharSequence;III)V
    .locals 3
    .param p1, "arg0"    # Ljava/lang/CharSequence;
    .param p2, "arg1"    # I
    .param p3, "arg2"    # I
    .param p4, "arg3"    # I

    .prologue
    const/4 v2, 0x4

    .line 280
    iget-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 281
    iget-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_passwd:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 282
    iget-object v0, p0, Lcom/dygame/dysdk/UserBindDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_verify_code:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 284
    return-void
.end method
