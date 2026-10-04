.class public Lorg/cocos2dx/utils/PSDialog;
.super Ljava/lang/Object;
.source "PSDialog.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/utils/PSDialog$PSDialogListener;
    }
.end annotation


# instance fields
.field private mButtonLabels:Ljava/util/Vector;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Vector",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mCancelable:Z

.field private mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

.field private mDialog:Landroid/app/AlertDialog;

.field private mDialogClickListener:Landroid/content/DialogInterface$OnClickListener;

.field private mDialogLuaListener:I

.field private mIcon:Landroid/graphics/drawable/Drawable;

.field private mMessage:Ljava/lang/String;

.field private mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

.field private mTitle:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lorg/cocos2dx/lib/Cocos2dxActivity;)V
    .locals 2
    .param p1, "context"    # Lorg/cocos2dx/lib/Cocos2dxActivity;

    .prologue
    const/4 v1, 0x0

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 20
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    .line 22
    const/4 v0, 0x0

    iput v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogLuaListener:I

    .line 23
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 24
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogClickListener:Landroid/content/DialogInterface$OnClickListener;

    .line 25
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    .line 27
    const/4 v0, 0x1

    iput-boolean v0, p0, Lorg/cocos2dx/utils/PSDialog;->mCancelable:Z

    .line 28
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mTitle:Ljava/lang/String;

    .line 29
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mMessage:Ljava/lang/String;

    .line 30
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mIcon:Landroid/graphics/drawable/Drawable;

    .line 31
    new-instance v0, Ljava/util/Vector;

    invoke-direct {v0}, Ljava/util/Vector;-><init>()V

    iput-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    .line 34
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    .line 36
    new-instance v0, Lorg/cocos2dx/utils/PSDialog$1;

    invoke-direct {v0, p0}, Lorg/cocos2dx/utils/PSDialog$1;-><init>(Lorg/cocos2dx/utils/PSDialog;)V

    iput-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogClickListener:Landroid/content/DialogInterface$OnClickListener;

    .line 57
    return-void
.end method

.method static synthetic access$0(Lorg/cocos2dx/utils/PSDialog;)I
    .locals 1

    .prologue
    .line 22
    iget v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogLuaListener:I

    return v0
.end method

.method static synthetic access$1(Lorg/cocos2dx/utils/PSDialog;)Lorg/cocos2dx/lib/Cocos2dxActivity;
    .locals 1

    .prologue
    .line 23
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    return-object v0
.end method


# virtual methods
.method public addAlertButton(Ljava/lang/String;)I
    .locals 2
    .param p1, "buttonTitle"    # Ljava/lang/String;

    .prologue
    .line 94
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v0}, Ljava/util/Vector;->size()I

    move-result v0

    const/4 v1, 0x3

    if-lt v0, v1, :cond_0

    .line 95
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v0}, Ljava/util/Vector;->size()I

    move-result v0

    .line 98
    :goto_0
    return v0

    .line 97
    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v0, p1}, Ljava/util/Vector;->add(Ljava/lang/Object;)Z

    .line 98
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v0}, Ljava/util/Vector;->size()I

    move-result v0

    goto :goto_0
.end method

.method public dismiss()V
    .locals 1

    .prologue
    .line 115
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lorg/cocos2dx/utils/PSDialog;->isShowing()Z

    move-result v0

    if-nez v0, :cond_1

    .line 124
    :cond_0
    :goto_0
    return-void

    .line 117
    :cond_1
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->dismiss()V

    .line 119
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    if-eqz v0, :cond_2

    .line 120
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    invoke-interface {v0, p0}, Lorg/cocos2dx/utils/PSDialog$PSDialogListener;->onDismiss(Lorg/cocos2dx/utils/PSDialog;)V

    .line 123
    :cond_2
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    goto :goto_0
.end method

.method public getButtonsCount()I
    .locals 1

    .prologue
    .line 90
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v0}, Ljava/util/Vector;->size()I

    move-result v0

    return v0
.end method

.method public hide()V
    .locals 1

    .prologue
    .line 108
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Lorg/cocos2dx/utils/PSDialog;->isShowing()Z

    move-result v0

    if-nez v0, :cond_1

    .line 112
    :cond_0
    :goto_0
    return-void

    .line 110
    :cond_1
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->dismiss()V

    .line 111
    const/4 v0, 0x0

    iput-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    goto :goto_0
.end method

.method public isShowing()Z
    .locals 1

    .prologue
    .line 102
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    if-nez v0, :cond_0

    .line 103
    const/4 v0, 0x0

    .line 104
    :goto_0
    return v0

    :cond_0
    iget-object v0, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    invoke-virtual {v0}, Landroid/app/AlertDialog;->isShowing()Z

    move-result v0

    goto :goto_0
.end method

.method public setCancelable(Z)Lorg/cocos2dx/utils/PSDialog;
    .locals 0
    .param p1, "flag"    # Z

    .prologue
    .line 65
    iput-boolean p1, p0, Lorg/cocos2dx/utils/PSDialog;->mCancelable:Z

    .line 66
    return-object p0
.end method

.method public setIcon(Landroid/graphics/drawable/Drawable;)Lorg/cocos2dx/utils/PSDialog;
    .locals 0
    .param p1, "icon"    # Landroid/graphics/drawable/Drawable;

    .prologue
    .line 85
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog;->mIcon:Landroid/graphics/drawable/Drawable;

    .line 86
    return-object p0
.end method

.method public setListener(Lorg/cocos2dx/utils/PSDialog$PSDialogListener;)Lorg/cocos2dx/utils/PSDialog;
    .locals 0
    .param p1, "listener"    # Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    .prologue
    .line 60
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog;->mPSDialogListener:Lorg/cocos2dx/utils/PSDialog$PSDialogListener;

    .line 61
    return-object p0
.end method

.method public setLuaListener(I)Lorg/cocos2dx/utils/PSDialog;
    .locals 0
    .param p1, "listener"    # I

    .prologue
    .line 80
    iput p1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogLuaListener:I

    .line 81
    return-object p0
.end method

.method public setMessage(Ljava/lang/String;)Lorg/cocos2dx/utils/PSDialog;
    .locals 0
    .param p1, "msg"    # Ljava/lang/String;

    .prologue
    .line 75
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog;->mMessage:Ljava/lang/String;

    .line 76
    return-object p0
.end method

.method public setTitle(Ljava/lang/String;)Lorg/cocos2dx/utils/PSDialog;
    .locals 0
    .param p1, "title"    # Ljava/lang/String;

    .prologue
    .line 70
    iput-object p1, p0, Lorg/cocos2dx/utils/PSDialog;->mTitle:Ljava/lang/String;

    .line 71
    return-object p0
.end method

.method public show()V
    .locals 4

    .prologue
    .line 127
    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    if-eqz v1, :cond_0

    invoke-virtual {p0}, Lorg/cocos2dx/utils/PSDialog;->isShowing()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 128
    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    invoke-virtual {v1}, Landroid/app/AlertDialog;->dismiss()V

    .line 158
    :goto_0
    return-void

    .line 132
    :cond_0
    new-instance v1, Landroid/app/AlertDialog$Builder;

    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mContext:Lorg/cocos2dx/lib/Cocos2dxActivity;

    invoke-direct {v1, v2}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    iget-boolean v2, p0, Lorg/cocos2dx/utils/PSDialog;->mCancelable:Z

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setCancelable(Z)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 133
    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mTitle:Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mMessage:Ljava/lang/String;

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    invoke-virtual {v1}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v1

    .line 132
    iput-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    .line 134
    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mTitle:Ljava/lang/String;

    if-eqz v1, :cond_1

    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mTitle:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_1

    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mIcon:Landroid/graphics/drawable/Drawable;

    if-eqz v1, :cond_1

    .line 135
    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mIcon:Landroid/graphics/drawable/Drawable;

    invoke-virtual {v1, v2}, Landroid/app/AlertDialog;->setIcon(Landroid/graphics/drawable/Drawable;)V

    .line 138
    :cond_1
    const/4 v0, 0x0

    .local v0, "i":I
    :goto_1
    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v1}, Ljava/util/Vector;->size()I

    move-result v1

    if-lt v0, v1, :cond_2

    .line 157
    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    invoke-virtual {v1}, Landroid/app/AlertDialog;->show()V

    goto :goto_0

    .line 139
    :cond_2
    packed-switch v0, :pswitch_data_0

    .line 138
    :goto_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 141
    :pswitch_0
    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v1, v0}, Ljava/util/Vector;->elementAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    .line 142
    iget-object v3, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogClickListener:Landroid/content/DialogInterface$OnClickListener;

    .line 141
    invoke-virtual {v2, v1, v3}, Landroid/app/AlertDialog;->setButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)V

    goto :goto_2

    .line 145
    :pswitch_1
    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v1, v0}, Ljava/util/Vector;->elementAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    .line 146
    iget-object v3, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogClickListener:Landroid/content/DialogInterface$OnClickListener;

    .line 145
    invoke-virtual {v2, v1, v3}, Landroid/app/AlertDialog;->setButton2(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)V

    goto :goto_2

    .line 149
    :pswitch_2
    iget-object v2, p0, Lorg/cocos2dx/utils/PSDialog;->mDialog:Landroid/app/AlertDialog;

    iget-object v1, p0, Lorg/cocos2dx/utils/PSDialog;->mButtonLabels:Ljava/util/Vector;

    invoke-virtual {v1, v0}, Ljava/util/Vector;->elementAt(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/CharSequence;

    .line 150
    iget-object v3, p0, Lorg/cocos2dx/utils/PSDialog;->mDialogClickListener:Landroid/content/DialogInterface$OnClickListener;

    .line 149
    invoke-virtual {v2, v1, v3}, Landroid/app/AlertDialog;->setButton3(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)V

    goto :goto_2

    .line 139
    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
        :pswitch_2
    .end packed-switch
.end method
