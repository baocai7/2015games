.class Lcom/dygame/dysdk/LoginInputDlg$1;
.super Ljava/lang/Object;
.source "LoginInputDlg.java"

# interfaces
.implements Landroid/text/TextWatcher;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/dygame/dysdk/LoginInputDlg;->initWidgets()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/dygame/dysdk/LoginInputDlg;


# direct methods
.method constructor <init>(Lcom/dygame/dysdk/LoginInputDlg;)V
    .locals 0
    .param p1, "this$0"    # Lcom/dygame/dysdk/LoginInputDlg;

    .prologue
    .line 46
    iput-object p1, p0, Lcom/dygame/dysdk/LoginInputDlg$1;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .locals 0
    .param p1, "arg0"    # Landroid/text/Editable;

    .prologue
    .line 60
    return-void
.end method

.method public beforeTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0
    .param p1, "arg0"    # Ljava/lang/CharSequence;
    .param p2, "arg1"    # I
    .param p3, "arg2"    # I
    .param p4, "arg3"    # I

    .prologue
    .line 56
    return-void
.end method

.method public onTextChanged(Ljava/lang/CharSequence;III)V
    .locals 2
    .param p1, "arg0"    # Ljava/lang/CharSequence;
    .param p2, "arg1"    # I
    .param p3, "arg2"    # I
    .param p4, "arg3"    # I

    .prologue
    .line 50
    iget-object v0, p0, Lcom/dygame/dysdk/LoginInputDlg$1;->this$0:Lcom/dygame/dysdk/LoginInputDlg;

    iget-object v0, v0, Lcom/dygame/dysdk/LoginInputDlg;->mWidget:Lcom/dygame/common/unit/DYWidgetUnit;

    sget v1, Lcom/dygame/dysdk/R$id;->password_input:I

    invoke-virtual {v0, v1}, Lcom/dygame/common/unit/DYWidgetUnit;->getView(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    const-string v1, ""

    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 51
    return-void
.end method
