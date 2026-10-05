.class public Lcom/dygame/dysdk/ForgetPassDlg;
.super Landroid/app/Dialog;
.source "ForgetPassDlg.java"

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
    iput-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 29
    iput-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mHandlerCheck:Landroid/os/Handler;

    .line 30
    iput-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mBtnVerify:Landroid/widget/Button;

    .line 31
    iput-boolean v1, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mLoading:Z

    .line 36
    sget v0, Lcom/dygame/dysdk/R$layout;->dysdk_user_reg_dialog2:I

    invoke-virtual {p0, v0}, Lcom/dygame/dysdk/ForgetPassDlg;->setContentView(I)V

    .line 37
    invoke-virtual {p0, v1}, Lcom/dygame/dysdk/ForgetPassDlg;->setCancelable(Z)V

    .line 39
    invoke-virtual {p0}, Lcom/dygame/dysdk/ForgetPassDlg;->initWidgets()V

    .line 40
    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .locals 0
    .param p1, "arg0"    # Landroid/text/Editable;

    .prologue
    .line 258
    return-void
.end method

.method public beforeTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0
    .param p1, "arg0"    # Ljava/lang/CharSequence;
    .param p2, "arg1"    # I
    .param p3, "arg2"    # I
    .param p4, "arg3"    # I

    .prologue
    .line 263
    return-void
.end method

.method public dismiss()V
    .locals 0

    .prologue
    .line 97
    invoke-super {p0}, Landroid/app/Dialog;->dismiss()V

    .line 98
    invoke-static {p0}, Lcom/dygame/common/unit/DYUnit;->removeAllUnits(Lcom/dygame/common/unit/DYUnit$Target;)V

    .line 99
    return-void
.end method

.method public findView(I)Landroid/view/View;
    .locals 1
    .param p1, "resId"    # I

    .prologue
    .line 91
    invoke-virtual {p0, p1}, Lcom/dygame/dysdk/ForgetPassDlg;->findViewById(I)Landroid/view/View;

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

    iput-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 45
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_back:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 46
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_reigster_immediately:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 47
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->cb_display_passwd:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    invoke-virtual {v3, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 49
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->tv_reg_title:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/TextView;

    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_reset_passwd_title:I

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(I)V

    .line 50
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_reigster_immediately:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    sget v4, Lcom/dygame/dysdk/R$string;->dysdk_reset_immediately:I

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(I)V

    .line 51
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->btn_get_verify_code_bg:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/Button;

    iput-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mBtnVerify:Landroid/widget/Button;

    .line 53
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->email_input:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 54
    .local v0, "etAccount":Landroid/widget/EditText;
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 55
    .local v1, "etPass":Landroid/widget/EditText;
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v4, Lcom/dygame/dysdk/R$id;->verify_code_input:I

    invoke-virtual {v3, v4}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/EditText;

    .line 57
    .local v2, "etVerify":Landroid/widget/EditText;
    invoke-virtual {v0, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 58
    invoke-virtual {v1, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 59
    invoke-virtual {v2, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 61
    new-instance v3, Lcom/dygame/dysdk/ForgetPassDlg$1;

    invoke-direct {v3, p0}, Lcom/dygame/dysdk/ForgetPassDlg$1;-><init>(Lcom/dygame/dysdk/ForgetPassDlg;)V

    iput-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mHandlerCheck:Landroid/os/Handler;

    .line 85
    iget-object v3, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mHandlerCheck:Landroid/os/Handler;

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    .line 86
    return-void
.end method

.method public onBackPressed()V
    .locals 2

    .prologue
    .line 252
    invoke-super {p0}, Landroid/app/Dialog;->onBackPressed()V

    .line 253
    iget-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->btn_back:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {p0, v0}, Lcom/dygame/dysdk/ForgetPassDlg;->onClick(Landroid/view/View;)V

    .line 254
    return-void
.end method

.method public onCheckDisplayPasswd()V
    .locals 4

    .prologue
    .line 121
    iget-object v2, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->cb_display_passwd:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/CheckBox;

    .line 122
    .local v0, "cbCheck":Landroid/widget/CheckBox;
    iget-object v2, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 124
    .local v1, "etPass":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/CheckBox;->isChecked()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 126
    invoke-static {}, Landroid/text/method/HideReturnsTransformationMethod;->getInstance()Landroid/text/method/HideReturnsTransformationMethod;

    move-result-object v2

    .line 125
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setTransformationMethod(Landroid/text/method/TransformationMethod;)V

    .line 131
    :goto_0
    return-void

    .line 129
    :cond_0
    invoke-static {}, Landroid/text/method/PasswordTransformationMethod;->getInstance()Landroid/text/method/PasswordTransformationMethod;

    move-result-object v2

    .line 128
    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setTransformationMethod(Landroid/text/method/TransformationMethod;)V

    goto :goto_0
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3
    .param p1, "arg0"    # Landroid/view/View;

    .prologue
    .line 103
    iget-boolean v1, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mLoading:Z

    if-eqz v1, :cond_1

    .line 119
    :cond_0
    :goto_0
    return-void

    .line 107
    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    .line 108
    .local v0, "resId":I
    sget v1, Lcom/dygame/dysdk/R$id;->btn_back:I

    if-ne v0, v1, :cond_2

    .line 109
    const-string v1, "DYGame"

    const-string v2, "btn_back"

    invoke-static {v1, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 110
    invoke-virtual {p0}, Lcom/dygame/dysdk/ForgetPassDlg;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/dygame/dysdk/DYSdkHelper;->showLoginDlg(Landroid/content/Context;)V

    .line 111
    invoke-virtual {p0}, Lcom/dygame/dysdk/ForgetPassDlg;->dismiss()V

    goto :goto_0

    .line 112
    :cond_2
    sget v1, Lcom/dygame/dysdk/R$id;->btn_reigster_immediately:I

    if-ne v0, v1, :cond_3

    .line 113
    invoke-virtual {p0}, Lcom/dygame/dysdk/ForgetPassDlg;->onClickReset()V

    goto :goto_0

    .line 114
    :cond_3
    sget v1, Lcom/dygame/dysdk/R$id;->btn_get_verify_code_bg:I

    if-ne v0, v1, :cond_4

    .line 115
    invoke-virtual {p0}, Lcom/dygame/dysdk/ForgetPassDlg;->onClickGetVerify()V

    goto :goto_0

    .line 116
    :cond_4
    sget v1, Lcom/dygame/dysdk/R$id;->cb_display_passwd:I

    if-ne v0, v1, :cond_0

    .line 117
    invoke-virtual {p0}, Lcom/dygame/dysdk/ForgetPassDlg;->onCheckDisplayPasswd()V

    goto :goto_0
.end method

.method public onClickGetVerify()V
    .locals 9

    .prologue
    const/4 v8, 0x0

    .line 134
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->leftTickForGetVerify()J

    move-result-wide v2

    .line 135
    .local v2, "left":J
    const-wide/16 v6, 0x0

    cmp-long v6, v2, v6

    if-lez v6, :cond_0

    .line 153
    :goto_0
    return-void

    .line 139
    :cond_0
    iget-object v6, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->email_input:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 140
    .local v0, "etAccount":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    .line 141
    .local v4, "tName":Ljava/lang/String;
    invoke-static {v4}, Lcom/dygame/dysdk/DYSdkHelper;->isValidMobile(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_1

    .line 142
    iget-object v6, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v6

    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 146
    :cond_1
    invoke-static {}, Lcom/dygame/dysdk/DYSdkHelper;->saveTickForGetVerify()V

    .line 147
    sget-object v5, Lcom/dygame/dysdk/DYSDK;->URI_GEN_VERIFY:Ljava/lang/String;

    .line 148
    .local v5, "uri":Ljava/lang/String;
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 149
    .local v1, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v6, "telephone"

    invoke-virtual {v1, v6, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 150
    const/4 v6, 0x0

    invoke-static {v5, v1, v6}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

    .line 152
    iget-object v6, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mHandlerCheck:Landroid/os/Handler;

    invoke-virtual {v6, v8}, Landroid/os/Handler;->sendEmptyMessage(I)Z

    goto :goto_0
.end method

.method public onClickReset()V
    .locals 11

    .prologue
    const/4 v10, 0x0

    .line 156
    iget-object v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v9, Lcom/dygame/dysdk/R$id;->email_input:I

    invoke-virtual {v8, v9}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 157
    .local v0, "etAccount":Landroid/widget/EditText;
    iget-object v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v9, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v8, v9}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 158
    .local v1, "etPass":Landroid/widget/EditText;
    iget-object v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v9, Lcom/dygame/dysdk/R$id;->verify_code_input:I

    invoke-virtual {v8, v9}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/EditText;

    .line 160
    .local v2, "etVerify":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    .line 161
    .local v4, "tName":Ljava/lang/String;
    invoke-static {v4}, Lcom/dygame/dysdk/DYSdkHelper;->isValidMobile(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_0

    .line 162
    iget-object v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v9, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v8, v9}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v8

    invoke-virtual {v8, v10}, Landroid/view/View;->setVisibility(I)V

    .line 247
    :goto_0
    return-void

    .line 166
    :cond_0
    invoke-virtual {v1}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    .line 167
    .local v5, "tPass":Ljava/lang/String;
    invoke-static {v5}, Lcom/dygame/dysdk/DYSdkHelper;->isValidPasswd(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_1

    .line 168
    iget-object v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v9, Lcom/dygame/dysdk/R$id;->invalid_passwd:I

    invoke-virtual {v8, v9}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v8

    invoke-virtual {v8, v10}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 172
    :cond_1
    invoke-virtual {v2}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v6

    .line 173
    .local v6, "tVerify":Ljava/lang/String;
    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v8

    if-gtz v8, :cond_2

    .line 174
    iget-object v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v9, Lcom/dygame/dysdk/R$id;->invalid_verify_code:I

    invoke-virtual {v8, v9}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v8

    invoke-virtual {v8, v10}, Landroid/view/View;->setVisibility(I)V

    goto :goto_0

    .line 179
    :cond_2
    const/4 v8, 0x1

    iput-boolean v8, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mLoading:Z

    .line 180
    sget-object v7, Lcom/dygame/dysdk/DYSDK;->URI_RESET:Ljava/lang/String;

    .line 181
    .local v7, "uri":Ljava/lang/String;
    new-instance v3, Ljava/util/HashMap;

    invoke-direct {v3}, Ljava/util/HashMap;-><init>()V

    .line 182
    .local v3, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v8, "username"

    invoke-virtual {v3, v8, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 183
    const-string v8, "password"

    invoke-virtual {v3, v8, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 184
    const-string v8, "code"

    invoke-virtual {v3, v8, v6}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 186
    new-instance v8, Lcom/dygame/dysdk/ForgetPassDlg$2;

    invoke-direct {v8, p0}, Lcom/dygame/dysdk/ForgetPassDlg$2;-><init>(Lcom/dygame/dysdk/ForgetPassDlg;)V

    invoke-static {v7, v3, v8}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

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

    .line 267
    iget-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 268
    iget-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_passwd:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 269
    iget-object v0, p0, Lcom/dygame/dysdk/ForgetPassDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_verify_code:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 271
    return-void
.end method
