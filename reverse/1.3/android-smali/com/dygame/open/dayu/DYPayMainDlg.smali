.class public Lcom/dygame/open/dayu/DYPayMainDlg;
.super Landroid/app/Dialog;
.source "DYPayMainDlg.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/dygame/open/dayu/DYPayMainDlg$OnPayMainCancelListener;
    }
.end annotation


# instance fields
.field private mBtnAlipay:Landroid/view/View;

.field private mBtnCancel:Landroid/view/View;

.field private mBtnWeixin:Landroid/view/View;

.field public mPayParam:Ljava/lang/String;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;

    .prologue
    const/4 v0, 0x0

    .line 56
    invoke-direct {p0, p1}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    .line 48
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnAlipay:Landroid/view/View;

    .line 49
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnWeixin:Landroid/view/View;

    .line 50
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnCancel:Landroid/view/View;

    .line 52
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mPayParam:Ljava/lang/String;

    .line 57
    invoke-direct {p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->initDialog()V

    .line 58
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;I)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "theme"    # I

    .prologue
    const/4 v0, 0x0

    .line 61
    invoke-direct {p0, p1, p2}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V

    .line 48
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnAlipay:Landroid/view/View;

    .line 49
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnWeixin:Landroid/view/View;

    .line 50
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnCancel:Landroid/view/View;

    .line 52
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mPayParam:Ljava/lang/String;

    .line 62
    invoke-direct {p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->initDialog()V

    .line 63
    return-void
.end method

.method protected constructor <init>(Landroid/content/Context;ZLandroid/content/DialogInterface$OnCancelListener;)V
    .locals 1
    .param p1, "context"    # Landroid/content/Context;
    .param p2, "cancelable"    # Z
    .param p3, "cancelListener"    # Landroid/content/DialogInterface$OnCancelListener;

    .prologue
    const/4 v0, 0x0

    .line 67
    invoke-direct {p0, p1, p2, p3}, Landroid/app/Dialog;-><init>(Landroid/content/Context;ZLandroid/content/DialogInterface$OnCancelListener;)V

    .line 48
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnAlipay:Landroid/view/View;

    .line 49
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnWeixin:Landroid/view/View;

    .line 50
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnCancel:Landroid/view/View;

    .line 52
    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mPayParam:Ljava/lang/String;

    .line 68
    invoke-direct {p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->initDialog()V

    .line 69
    return-void
.end method

.method private initDialog()V
    .locals 1

    .prologue
    .line 72
    const v0, 0x7f030001

    invoke-virtual {p0, v0}, Lcom/dygame/open/dayu/DYPayMainDlg;->setContentView(I)V

    .line 74
    const v0, 0x7f080008

    invoke-virtual {p0, v0}, Lcom/dygame/open/dayu/DYPayMainDlg;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnAlipay:Landroid/view/View;

    .line 75
    iget-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnAlipay:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 77
    const v0, 0x7f08000a

    invoke-virtual {p0, v0}, Lcom/dygame/open/dayu/DYPayMainDlg;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnWeixin:Landroid/view/View;

    .line 78
    iget-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnWeixin:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 80
    const v0, 0x7f080005

    invoke-virtual {p0, v0}, Lcom/dygame/open/dayu/DYPayMainDlg;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnCancel:Landroid/view/View;

    .line 81
    iget-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnCancel:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 82
    return-void
.end method

.method public static tryPay(Landroid/content/Intent;ILandroid/content/DialogInterface$OnCancelListener;)V
    .locals 2
    .param p0, "intent"    # Landroid/content/Intent;
    .param p1, "requestCode"    # I
    .param p2, "listener"    # Landroid/content/DialogInterface$OnCancelListener;

    .prologue
    .line 23
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    .line 24
    .local v0, "act":Landroid/app/Activity;
    new-instance v1, Lcom/dygame/open/dayu/DYPayMainDlg$1;

    invoke-direct {v1, p0, p1}, Lcom/dygame/open/dayu/DYPayMainDlg$1;-><init>(Landroid/content/Intent;I)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    .line 32
    return-void
.end method

.method public static tryPay(Ljava/lang/String;)V
    .locals 3
    .param p0, "param"    # Ljava/lang/String;
    .annotation build Landroid/annotation/SuppressLint;
        value = {
            "InlinedApi"
        }
    .end annotation

    .prologue
    .line 36
    new-instance v0, Lcom/dygame/open/dayu/DYPayMainDlg;

    sget-object v1, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    const/high16 v2, 0x7f070000

    invoke-direct {v0, v1, v2}, Lcom/dygame/open/dayu/DYPayMainDlg;-><init>(Landroid/content/Context;I)V

    .line 37
    .local v0, "dlg":Lcom/dygame/open/dayu/DYPayMainDlg;
    new-instance v1, Lcom/dygame/open/dayu/DYPayMainDlg$2;

    invoke-direct {v1}, Lcom/dygame/open/dayu/DYPayMainDlg$2;-><init>()V

    invoke-virtual {v0, v1}, Lcom/dygame/open/dayu/DYPayMainDlg;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)V

    .line 43
    invoke-virtual {v0, p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->setPayParam(Ljava/lang/String;)V

    .line 44
    invoke-virtual {v0}, Lcom/dygame/open/dayu/DYPayMainDlg;->show()V

    .line 45
    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2
    .param p1, "arg0"    # Landroid/view/View;

    .prologue
    .line 90
    iget-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnAlipay:Landroid/view/View;

    if-ne p1, v0, :cond_1

    .line 91
    invoke-static {}, Lcom/dygame/open/dayu/DYAlipayHelper;->getInstance()Lcom/dygame/open/dayu/DYAlipayHelper;

    move-result-object v0

    iget-object v1, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mPayParam:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/dygame/open/dayu/DYAlipayHelper;->pay(Ljava/lang/String;)V

    .line 92
    invoke-virtual {p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->dismiss()V

    .line 101
    :cond_0
    :goto_0
    return-void

    .line 94
    :cond_1
    iget-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnWeixin:Landroid/view/View;

    if-ne p1, v0, :cond_2

    .line 95
    invoke-static {}, Lcom/dygame/open/dayu/DYWxpayHelper;->getInstance()Lcom/dygame/open/dayu/DYWxpayHelper;

    move-result-object v0

    iget-object v1, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mPayParam:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/dygame/open/dayu/DYWxpayHelper;->pay(Ljava/lang/String;)V

    .line 96
    invoke-virtual {p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->dismiss()V

    goto :goto_0

    .line 98
    :cond_2
    iget-object v0, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mBtnCancel:Landroid/view/View;

    if-ne p1, v0, :cond_0

    .line 99
    invoke-virtual {p0}, Lcom/dygame/open/dayu/DYPayMainDlg;->cancel()V

    goto :goto_0
.end method

.method protected setPayParam(Ljava/lang/String;)V
    .locals 0
    .param p1, "param"    # Ljava/lang/String;

    .prologue
    .line 85
    iput-object p1, p0, Lcom/dygame/open/dayu/DYPayMainDlg;->mPayParam:Ljava/lang/String;

    .line 86
    return-void
.end method
