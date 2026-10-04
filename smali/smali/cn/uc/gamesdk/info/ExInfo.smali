.class public Lcn/uc/gamesdk/info/ExInfo;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/io/Serializable;


# static fields
.field private static final a:J = 0x34a87e9822449d28L


# instance fields
.field private b:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getCpServiceContact()Ljava/lang/String;
    .locals 1

    iget-object v0, p0, Lcn/uc/gamesdk/info/ExInfo;->b:Ljava/lang/String;

    return-object v0
.end method

.method public setCpServiceContact(Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcn/uc/gamesdk/info/ExInfo;->b:Ljava/lang/String;

    return-void
.end method
