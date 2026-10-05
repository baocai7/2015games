.class final Lcom/dygame/open/dayu/DYPayMainDlg$2;
.super Ljava/lang/Object;
.source "DYPayMainDlg.java"

# interfaces
.implements Landroid/content/DialogInterface$OnCancelListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYPayMainDlg;->tryPay(Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .prologue
    .line 37
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCancel(Landroid/content/DialogInterface;)V
    .locals 2
    .param p1, "arg0"    # Landroid/content/DialogInterface;

    .prologue
    .line 40
    invoke-static {}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->getInstance()Lcom/dygame/open/dayu/DYIAPHandlerDayu;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/dygame/open/dayu/DYIAPHandlerDayu;->afterPay(Z)V

    .line 41
    return-void
.end method
