.class public Lcom/dygame/dysdk/LoginInputDlg;
.super Landroid/app/Dialog;
.source "LoginInputDlg.java"

# interfaces
.implements Landroid/view/View$OnClickListener;
.implements Lcom/dygame/common/unit/DYUnit$Target;
.implements Landroid/text/TextWatcher;


# instance fields
.field protected mLoading:Z

.field protected mWidget:Lcom/dygame/common/unit/DYWidgetUnit;


# direct methods
.method public constructor <init>(Landroid/content/Context;I)V
    .locals 2
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "theme"    # I

    .prologue
    const/4 v1, 0x0

    .line 26
    invoke-direct {p0, p1, p2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    .line 22
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 23
    iput-boolean v1, p0, Lcom/dygame/dysdk/LoginInputDlg;->mLoading:Z

    .line 28
    sget v0, Lcom/dygame/dysdk/R$layout;->dysdk_login_input_dialog2:I

    invoke-virtual {p0, v0}, Lcom/dygame/dysdk/LoginInputDlg;->setContentView(I)V

    .line 29
    invoke-virtual {p0, v1}, Lcom/dygame/dysdk/LoginInputDlg;->setCancelable(Z)V

    .line 31
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->initWidgets()V

    .line 32
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
    .line 72
    invoke-super {p0}, Landroid/app/Dialog;->dismiss()V

    .line 73
    invoke-static {p0}, Lcom/dygame/common/unit/DYUnit;->removeAllUnits(Lcom/dygame/common/unit/DYUnit$Target;)V

    .line 74
    return-void
.end method

.method public findView(I)Landroid/view/View;
    .locals 1
    .param p1, "resId"    # I

    .prologue
    .line 266
    invoke-virtual {p0, p1}, Lcom/dygame/dysdk/LoginInputDlg;->findViewById(I)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method protected initWidgets()V
    .locals 4

    .prologue
    .line 35
    const-class v2, Lcom/dygame/common/unit/DYWidgetUnit;

    invoke-static {p0, v2}, Lcom/dygame/common/unit/DYUnit;->addUnit(Lcom/dygame/common/unit/DYUnit$Target;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/dygame/common/unit/DYWidgetUnit;

    iput-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    .line 37
    iget-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->btn_account_login:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 38
    iget-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->btn_guest_login:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 39
    iget-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->tv_others_register:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 40
    iget-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->tv_forgot_passwd:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 42
    iget-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->account_input:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 43
    .local v0, "etAccount":Landroid/widget/EditText;
    iget-object v2, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v3, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v2, v3}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 45
    .local v1, "etPasswd":Landroid/widget/EditText;
    invoke-virtual {v0, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 46
    new-instance v2, Lcom/dygame/dysdk/LoginInputDlg$1;

    invoke-direct {v2, p0}, Lcom/dygame/dysdk/LoginInputDlg$1;-><init>(Lcom/dygame/dysdk/LoginInputDlg;)V

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 63
    invoke-virtual {v1, p0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 65
    sget-object v2, Lcom/dygame/dysdk/DYSDK;->CACHE_NAME:Ljava/lang/String;

    invoke-virtual {v0, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 66
    sget-object v2, Lcom/dygame/dysdk/DYSDK;->CACHE_PASS:Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 67
    return-void
.end method

.method public onBackPressed()V
    .locals 0

    .prologue
    .line 260
    invoke-super {p0}, Landroid/app/Dialog;->onBackPressed()V

    .line 261
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "arg0"    # Landroid/view/View;

    .prologue
    .line 78
    iget-boolean v1, p0, Lcom/dygame/dysdk/LoginInputDlg;->mLoading:Z

    if-eqz v1, :cond_1

    .line 95
    :cond_0
    :goto_0
    return-void

    .line 81
    :cond_1
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/dygame/dysdk/LoginInputDlg;->mLoading:Z

    .line 83
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result v0

    .line 84
    .local v0, "resId":I
    sget v1, Lcom/dygame/dysdk/R$id;->btn_account_login:I

    if-ne v0, v1, :cond_2

    .line 85
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->onClickAccountLogin()V

    goto :goto_0

    .line 86
    :cond_2
    sget v1, Lcom/dygame/dysdk/R$id;->btn_guest_login:I

    if-ne v0, v1, :cond_3

    .line 87
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->onClickGuestLogin()V

    goto :goto_0

    .line 88
    :cond_3
    sget v1, Lcom/dygame/dysdk/R$id;->tv_others_register:I

    if-ne v0, v1, :cond_4

    .line 89
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/dygame/dysdk/DYSdkHelper;->showRigisterDlg(Landroid/content/Context;)V

    .line 90
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->dismiss()V

    goto :goto_0

    .line 91
    :cond_4
    sget v1, Lcom/dygame/dysdk/R$id;->tv_forgot_passwd:I

    if-ne v0, v1, :cond_0

    .line 92
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/dygame/dysdk/DYSdkHelper;->showResetDlg(Landroid/content/Context;)V

    .line 93
    invoke-virtual {p0}, Lcom/dygame/dysdk/LoginInputDlg;->dismiss()V

    goto :goto_0
.end method

.method public onClickAccountLogin()V
    .locals 9

    .prologue
    const/4 v8, 0x0

    .line 168
    iget-object v6, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->account_input:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    .line 169
    .local v0, "etAccount":Landroid/widget/EditText;
    iget-object v6, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 171
    .local v1, "etPass":Landroid/widget/EditText;
    invoke-virtual {v0}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    .line 172
    .local v3, "tName":Ljava/lang/String;
    invoke-static {v3}, Lcom/dygame/dysdk/DYSdkHelper;->isValidMobile(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 173
    iget-object v6, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v6

    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V

    .line 174
    iput-boolean v8, p0, Lcom/dygame/dysdk/LoginInputDlg;->mLoading:Z

    .line 255
    :goto_0
    return-void

    .line 178
    :cond_0
    invoke-virtual {v1}, Landroid/widget/EditText;->getEditableText()Landroid/text/Editable;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    .line 179
    .local v4, "tPass":Ljava/lang/String;
    invoke-static {v4}, Lcom/dygame/dysdk/DYSdkHelper;->isValidPasswd(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_1

    .line 180
    iget-object v6, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v7, Lcom/dygame/dysdk/R$id;->invalid_password:I

    invoke-virtual {v6, v7}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v6

    invoke-virtual {v6, v8}, Landroid/view/View;->setVisibility(I)V

    .line 181
    iput-boolean v8, p0, Lcom/dygame/dysdk/LoginInputDlg;->mLoading:Z

    goto :goto_0

    .line 185
    :cond_1
    sput-object v3, Lcom/dygame/dysdk/DYSDK;->CACHE_NAME:Ljava/lang/String;

    .line 186
    sput-object v4, Lcom/dygame/dysdk/DYSDK;->CACHE_PASS:Ljava/lang/String;

    .line 188
    sget-object v5, Lcom/dygame/dysdk/DYSDK;->URI_LOGIN:Ljava/lang/String;

    .line 189
    .local v5, "uri":Ljava/lang/String;
    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    .line 190
    .local v2, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    const-string v6, "username"

    invoke-virtual {v2, v6, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 191
    const-string v6, "password"

    invoke-virtual {v2, v6, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 193
    new-instance v6, Lcom/dygame/dysdk/LoginInputDlg$3;

    invoke-direct {v6, p0}, Lcom/dygame/dysdk/LoginInputDlg$3;-><init>(Lcom/dygame/dysdk/LoginInputDlg;)V

    invoke-static {v5, v2, v6}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

    goto :goto_0
.end method

.method public onClickGuestLogin()V
    .locals 3

    .prologue
    .line 98
    sget-object v1, Lcom/dygame/dysdk/DYSDK;->URI_QUICK_REGISTER:Ljava/lang/String;

    .line 99
    .local v1, "uri":Ljava/lang/String;
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 100
    .local v0, "hmParam":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    new-instance v2, Lcom/dygame/dysdk/LoginInputDlg$2;

    invoke-direct {v2, p0}, Lcom/dygame/dysdk/LoginInputDlg$2;-><init>(Lcom/dygame/dysdk/LoginInputDlg;)V

    invoke-static {v1, v0, v2}, Lcom/dygame/dysdk/DYHttpMgr;->get(Ljava/lang/String;Ljava/util/HashMap;Lcom/dygame/dysdk/DYHttpMgr$DYHttpHandler;)V

    .line 165
    return-void
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
    iget-object v0, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_username:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 281
    iget-object v0, p0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->invalid_password:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 282
    return-void
.end method
