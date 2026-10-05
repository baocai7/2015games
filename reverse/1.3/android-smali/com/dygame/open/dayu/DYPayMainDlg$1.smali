.class final Lcom/dygame/open/dayu/DYPayMainDlg$1;
.super Ljava/lang/Object;
.source "DYPayMainDlg.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/open/dayu/DYPayMainDlg;->tryPay(Landroid/content/Intent;ILandroid/content/DialogInterface$OnCancelListener;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = null
.end annotation


# instance fields
.field final synthetic val$intent:Landroid/content/Intent;

.field final synthetic val$requestCode:I


# direct methods
.method constructor <init>(Landroid/content/Intent;I)V
    .locals 0

    .prologue
    .line 24
    iput-object p1, p0, Lcom/dygame/open/dayu/DYPayMainDlg$1;->val$intent:Landroid/content/Intent;

    iput p2, p0, Lcom/dygame/open/dayu/DYPayMainDlg$1;->val$requestCode:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .prologue
    .line 28
    sget-object v0, Lcom/dygame/common/DYGame;->theActivity:Lcom/dygame/common/DYGame;

    iget-object v1, p0, Lcom/dygame/open/dayu/DYPayMainDlg$1;->val$intent:Landroid/content/Intent;

    iget v2, p0, Lcom/dygame/open/dayu/DYPayMainDlg$1;->val$requestCode:I

    invoke-virtual {v0, v1, v2}, Lcom/dygame/common/DYGame;->startActivityForResult(Landroid/content/Intent;I)V

    .line 29
    return-void
.end method
